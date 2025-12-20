const express = require('express');
const router = express.Router();
const Place = require('../models/Place');
// Auth middleware is optional for now
const auth = (req, res, next) => next();

// Get places with budget filtering
router.get('/filter', auth, async (req, res) => {
    try {
        const { minPrice, maxPrice, category, search } = req.query;

        let query = {};

        if (minPrice && maxPrice) {
            query.price = { $gte: parseFloat(minPrice), $lte: parseFloat(maxPrice) };
        }

        if (category && category !== 'All') {
            query.category = category;
        }

        if (search) {
            query.$or = [
                { name: { $regex: search, $options: 'i' } },
                { description: { $regex: search, $options: 'i' } }
            ];
        }

        const places = await Place.find(query).sort({ rating: -1 });
        res.json(places);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Generate smart daily plan
router.post('/generate-plan', auth, async (req, res) => {
    try {
        const { totalBudget, minPrice, maxPrice, preferences } = req.body;

        // Get places within budget
        const places = await Place.find({
            price: { $gte: minPrice, $lte: maxPrice }
        }).sort({ rating: -1 });

        // Smart algorithm to create daily plan
        let selectedPlaces = [];
        let currentBudget = 0;
        let timeSlots = [
            { time: '09:00 AM', duration: 2 },
            { time: '12:00 PM', duration: 1.5 },
            { time: '03:00 PM', duration: 2 },
            { time: '06:00 PM', duration: 2 }
        ];

        for (let i = 0; i < places.length && selectedPlaces.length < timeSlots.length; i++) {
            const place = places[i];
            if (currentBudget + place.price <= totalBudget) {
                selectedPlaces.push({
                    ...place.toObject(),
                    scheduledTime: timeSlots[selectedPlaces.length].time,
                    duration: timeSlots[selectedPlaces.length].duration
                });
                currentBudget += place.price;
            }
        }

        res.json({
            plan: selectedPlaces,
            totalCost: currentBudget,
            remainingBudget: totalBudget - currentBudget
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// AI Chat endpoint
router.post('/ai-chat', auth, async (req, res) => {
    try {
        const { message, userBudget, currentPlan } = req.body;

        // Simple AI response logic (can be enhanced with actual AI service)
        let response = '';

        if (message.toLowerCase().includes('budget') || message.toLowerCase().includes('ميزانية')) {
            response = `بناءً على ميزانيتك ${userBudget} جنيه، أنصحك بزيارة الأماكن التالية التي تناسب ميزانيتك وتضمن لك يوم رائع!`;
        } else if (message.toLowerCase().includes('suggest') || message.toLowerCase().includes('اقترح')) {
            const places = await Place.find({ price: { $lte: userBudget / 3 } }).limit(3);
            response = `إليك بعض الأماكن الرائعة:\n${places.map(p => `- ${p.name} (${p.price} جنيه)`).join('\n')}`;
        } else if (message.toLowerCase().includes('plan') || message.toLowerCase().includes('خطة')) {
            response = 'يمكنني مساعدتك في تنظيم خطة يومك! فقط أخبرني بميزانيتك وتفضيلاتك.';
        } else {
            response = 'كيف يمكنني مساعدتك في تخطيط يومك؟ يمكنني اقتراح أماكن، تنظيم خطة، أو مساعدتك في إدارة ميزانيتك.';
        }

        res.json({ response });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
