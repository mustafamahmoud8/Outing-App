const Engagement = require('../models/Engagement');
const Captain = require('../models/Captain');
const Place = require('../models/Place');
const Plan = require('../models/Plan');

/**
 * Create new engagement with time table
 * POST /api/engagements
 */
exports.createEngagement = async (req, res) => {
  try {
    const userId = req.user._id; // from auth middleware
    const {
      title,
      date,
      timeTable,
      totalBudget,
      notes,
      planId,
      captainService,
      participants
    } = req.body;

    // Validate required fields
    if (!title || !date || !timeTable || timeTable.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Title, date, and time table are required'
      });
    }

    // Verify all places exist
    const placeIds = timeTable.map(item => item.place);
    const places = await Place.find({ _id: { $in: placeIds }, isActive: true });

    if (places.length !== placeIds.length) {
      return res.status(400).json({
        success: false,
        message: 'One or more places not found or inactive'
      });
    }

    // Create engagement
    const engagement = new Engagement({
      user: userId,
      plan: planId || null,
      title,
      date: new Date(date),
      timeTable: timeTable.map((item, index) => ({
        place: item.place,
        placeName: item.placeName,
        startTime: item.startTime,
        endTime: item.endTime,
        duration: item.duration,
        notes: item.notes,
        order: index + 1,
        estimatedCost: item.estimatedCost || 0,
        status: 'pending'
      })),
      totalBudget: totalBudget || null,
      notes: notes || null,
      captainService: captainService || {
        isRequested: false
      },
      participants: participants || [],
      liveLocationSharing: {
        isEnabled: false,
        sharedWith: []
      },
      proximityNotifications: {
        isEnabled: true,
        notificationRadius: 500,
        notificationsSent: []
      }
    });

    await engagement.save();

    // Populate references
    await engagement.populate('timeTable.place');
    await engagement.populate('plan');

    return res.status(201).json({
      success: true,
      message: 'Engagement created successfully',
      data: { engagement }
    });

  } catch (error) {
    console.error('Create engagement error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while creating engagement',
      error: error.message
    });
  }
};

/**
 * Request captain/driver service
 * POST /api/engagements/:engagementId/request-captain
 */
exports.requestCaptain = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const userId = req.user._id;
    const { pickupLocation, pickupTime, estimatedFare } = req.body;

    const engagement = await Engagement.findOne({
      _id: engagementId,
      user: userId
    });

    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    // Update captain service request
    engagement.captainService = {
      isRequested: true,
      pickupLocation: {
        address: pickupLocation.address,
        latitude: pickupLocation.latitude,
        longitude: pickupLocation.longitude
      },
      pickupTime,
      estimatedFare: estimatedFare || null,
      captainStatus: 'pending'
    };

    await engagement.save();

    return res.status(200).json({
      success: true,
      message: 'Captain service requested successfully',
      data: { captainService: engagement.captainService }
    });

  } catch (error) {
    console.error('Request captain error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while requesting captain',
      error: error.message
    });
  }
};

/**
 * Assign captain to engagement (for captain app/admin)
 * PUT /api/engagements/:engagementId/assign-captain
 */
exports.assignCaptain = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const { captainId } = req.body;

    const engagement = await Engagement.findById(engagementId);
    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    const captain = await Captain.findById(captainId);
    if (!captain || !captain.isActive || !captain.isAvailable) {
      return res.status(400).json({
        success: false,
        message: 'Captain not available'
      });
    }

    engagement.captainService.captain = captainId;
    engagement.captainService.captainStatus = 'accepted';
    await engagement.save();

    await engagement.populate('captainService.captain');

    return res.status(200).json({
      success: true,
      message: 'Captain assigned successfully',
      data: { captainService: engagement.captainService }
    });

  } catch (error) {
    console.error('Assign captain error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while assigning captain',
      error: error.message
    });
  }
};

/**
 * Enable/Update live location sharing
 * PUT /api/engagements/:engagementId/live-location
 */
exports.updateLiveLocation = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const userId = req.user._id;
    const { isEnabled, latitude, longitude, sharedWith } = req.body;

    const engagement = await Engagement.findOne({
      _id: engagementId,
      user: userId
    });

    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    // Update live location
    engagement.liveLocationSharing.isEnabled = isEnabled !== undefined ? isEnabled : true;

    if (latitude && longitude) {
      engagement.liveLocationSharing.currentLocation = {
        latitude,
        longitude,
        lastUpdated: new Date()
      };
    }

    if (sharedWith) {
      engagement.liveLocationSharing.sharedWith = sharedWith;
    }

    await engagement.save();

    return res.status(200).json({
      success: true,
      message: 'Live location updated successfully',
      data: { liveLocationSharing: engagement.liveLocationSharing }
    });

  } catch (error) {
    console.error('Update live location error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while updating live location',
      error: error.message
    });
  }
};

/**
 * Check proximity and send notification
 * POST /api/engagements/:engagementId/check-proximity
 */
exports.checkProximity = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const userId = req.user._id;
    const { currentLatitude, currentLongitude } = req.body;

    const engagement = await Engagement.findOne({
      _id: engagementId,
      user: userId
    }).populate('timeTable.place');

    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    if (!engagement.proximityNotifications.isEnabled) {
      return res.status(200).json({
        success: true,
        message: 'Proximity notifications are disabled',
        data: { notifications: [] }
      });
    }

    const notifications = [];
    const radius = engagement.proximityNotifications.notificationRadius;

    // Check each place in the time table
    for (const item of engagement.timeTable) {
      const place = item.place;

      if (place.location && place.location.latitude && place.location.longitude) {
        // Calculate distance using Haversine formula
        const distance = calculateDistance(
          currentLatitude,
          currentLongitude,
          place.location.latitude,
          place.location.longitude
        );

        // Check if within notification radius
        if (distance <= radius) {
          // Check if notification already sent
          const alreadyNotified = engagement.proximityNotifications.notificationsSent.some(
            n => n.place.toString() === place._id.toString() && n.notified
          );

          if (!alreadyNotified) {
            notifications.push({
              place: {
                _id: place._id,
                name: place.name,
                address: place.address
              },
              distance: Math.round(distance),
              message: `You are ${Math.round(distance)}m away from ${place.name}`
            });

            // Mark as notified
            engagement.proximityNotifications.notificationsSent.push({
              place: place._id,
              sentAt: new Date(),
              notified: true
            });
          }
        }
      }
    }

    if (notifications.length > 0) {
      await engagement.save();
    }

    return res.status(200).json({
      success: true,
      message: notifications.length > 0 ? 'Proximity notifications sent' : 'No nearby places',
      data: { notifications }
    });

  } catch (error) {
    console.error('Check proximity error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while checking proximity',
      error: error.message
    });
  }
};

/**
 * Get user's engagements
 * GET /api/engagements
 */
exports.getUserEngagements = async (req, res) => {
  try {
    const userId = req.user._id;
    const { status, upcoming } = req.query;

    const query = { user: userId, isActive: true };

    if (status) {
      query.status = status;
    }

    if (upcoming === 'true') {
      query.date = { $gte: new Date() };
    }

    const engagements = await Engagement.find(query)
      .populate('timeTable.place')
      .populate('plan')
      .populate('captainService.captain')
      .sort({ date: -1 });

    return res.status(200).json({
      success: true,
      data: {
        engagements,
        total: engagements.length
      }
    });

  } catch (error) {
    console.error('Get engagements error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching engagements',
      error: error.message
    });
  }
};

/**
 * Get engagement by ID
 * GET /api/engagements/:engagementId
 */
exports.getEngagementById = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const userId = req.user._id;

    const engagement = await Engagement.findOne({
      _id: engagementId,
      user: userId
    })
      .populate('timeTable.place')
      .populate('plan')
      .populate('captainService.captain')
      .populate('liveLocationSharing.sharedWith.user', 'name phone')
      .populate('participants.user', 'name phone');

    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    return res.status(200).json({
      success: true,
      data: { engagement }
    });

  } catch (error) {
    console.error('Get engagement error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching engagement',
      error: error.message
    });
  }
};

/**
 * Update engagement status
 * PUT /api/engagements/:engagementId/status
 */
exports.updateEngagementStatus = async (req, res) => {
  try {
    const { engagementId } = req.params;
    const userId = req.user._id;
    const { status } = req.body;

    const engagement = await Engagement.findOne({
      _id: engagementId,
      user: userId
    });

    if (!engagement) {
      return res.status(404).json({
        success: false,
        message: 'Engagement not found'
      });
    }

    engagement.status = status;
    await engagement.save();

    return res.status(200).json({
      success: true,
      message: 'Engagement status updated',
      data: { engagement }
    });

  } catch (error) {
    console.error('Update engagement status error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while updating engagement',
      error: error.message
    });
  }
};

// Helper function to calculate distance between two coordinates (Haversine formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371e3; // Earth's radius in meters
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c; // Distance in meters
}
