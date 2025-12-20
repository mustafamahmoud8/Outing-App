# Outing Backend API Documentation

## Base URL
```
http://localhost:5000
```

## Authentication
Most endpoints require JWT authentication. Include the token in the header:
```
Authorization: Bearer <your_jwt_token>
```

---

# 1. AUTHENTICATION APIs

## 1.1 Send OTP
Send OTP to user's phone number for verification.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/send-otp` | No |

**Request Body:**
```json
{
  "phone": "01012345678"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

---

## 1.2 Verify OTP
Verify the OTP and get authentication token.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/verify-otp` | No |

**Request Body:**
```json
{
  "phone": "01012345678",
  "otp": "1234"
}
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "_id": "64a5b8c9d2e4f1234567890a",
    "phone": "01012345678",
    "name": "User Name"
  }
}
```

---

## 1.3 Google Login
Login/Register using Google account.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/google` | No |

**Request Body:**
```json
{
  "token": "google_id_token_here"
}
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "_id": "64a5b8c9d2e4f1234567890a",
    "email": "user@gmail.com",
    "name": "User Name"
  }
}
```

---

## 1.4 Facebook Login
Login/Register using Facebook account.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/facebook` | No |

**Request Body:**
```json
{
  "accessToken": "facebook_access_token_here"
}
```

---

## 1.5 Owner Register
Register a new business owner account.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/owner/register` | No |

**Request Body:**
```json
{
  "name": "Ahmed Mohamed",
  "email": "owner@example.com",
  "password": "securePassword123",
  "phone": "01012345678",
  "placeName": "Sunset Cafe",
  "placeType": "cafe",
  "placeAddress": "123 Main St, Cairo",
  "placePhone": "0225551234"
}
```

---

## 1.6 Owner Login
Login as business owner.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/auth/owner/login` | No |

**Request Body:**
```json
{
  "email": "owner@example.com",
  "password": "securePassword123"
}
```

---

# 2. USER PROFILE APIs

## 2.1 Get Profile
Get current user's profile.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/users/profile` | Yes |

**Response:**
```json
{
  "success": true,
  "user": {
    "_id": "64a5b8c9d2e4f1234567890a",
    "name": "User Name",
    "email": "user@example.com",
    "phone": "01012345678",
    "avatar": "https://example.com/avatar.jpg"
  }
}
```

---

## 2.2 Update Profile
Update current user's profile.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/users/profile` | Yes |

**Request Body:**
```json
{
  "name": "Ahmed Ali",
  "email": "ahmed@example.com",
  "phone": "01098765432",
  "avatar": "https://example.com/avatar.jpg"
}
```

---

# 3. CATEGORIES & PLACES APIs

## 3.1 Get All Categories
Get all available categories.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories` | No |

**Response:**
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "_id": "64a5b8c9d2e4f1234567890a",
        "nameAr": "مطاعم",
        "nameEn": "restaurants",
        "slug": "restaurants",
        "icon": "restaurant_icon",
        "image": "https://example.com/restaurant.jpg",
        "color": "#FF5733",
        "description": "Best restaurants in town",
        "placeCount": 25
      }
    ]
  }
}
```

---

## 3.2 Get Category by Slug
Get specific category details.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories/:slug` | No |

**Example:** `/api/categories/restaurants`

---

## 3.3 Get Places by Category
Get all places in a category.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories/:slug/places` | No |

**Example:** `/api/categories/restaurants/places`

**Response:**
```json
{
  "success": true,
  "data": {
    "category": {
      "_id": "...",
      "nameAr": "مطاعم",
      "nameEn": "restaurants"
    },
    "places": [
      {
        "_id": "64a5b8c9d2e4f123456789a0",
        "name": "Sunset Cafe",
        "price": 500,
        "address": "123 Main St, Cairo",
        "city": "Cairo",
        "rating": 4.5,
        "ratingCount": 120,
        "images": ["https://..."],
        "location": {
          "latitude": 30.0444,
          "longitude": 31.2357
        }
      }
    ]
  }
}
```

---

## 3.4 Search Places
Search places by query and city.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories/places/search` | No |

**Query Parameters:**
- `q` (required): Search query
- `city` (optional): Filter by city

**Example:** `/api/categories/places/search?q=cafe&city=Cairo`

---

## 3.5 Get Place by ID
Get detailed place information.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories/places/:placeId` | No |

---

## 3.6 Initialize Categories
Initialize default categories (admin use only).

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/categories/init` | No |

---

# 4. BUDGET FILTER APIs

## 4.1 Filter by Budget
Filter categories and places by user's budget.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/budget/filter` | No |

**Query Parameters:**
- `budget` (required): User's budget amount

**Example:** `/api/budget/filter?budget=1000`

**Response:**
```json
{
  "success": true,
  "message": "Found 15 places within your budget",
  "budget": 1000,
  "data": {
    "categories": [
      {
        "_id": "...",
        "nameAr": "مطاعم",
        "nameEn": "restaurants",
        "slug": "restaurants",
        "places": [
          {
            "_id": "...",
            "name": "Sunset Cafe",
            "price": 500,
            "address": "...",
            "rating": 4.5
          }
        ]
      }
    ],
    "totalPlaces": 15,
    "totalCategories": 5
  }
}
```

---

## 4.2 Get Place with Price
Get detailed place info including price.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/budget/place/:placeId` | No |

---

## 4.3 Select Place with Current Location
Select a place and get distance/navigation info.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/budget/select-place` | No |

**Request Body:**
```json
{
  "placeId": "64a5b8c9d2e4f123456789a0",
  "currentLocation": {
    "latitude": 30.0444,
    "longitude": 31.2357
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Place selected successfully",
  "data": {
    "place": {
      "_id": "...",
      "name": "Sunset Cafe",
      "price": 500,
      "address": "...",
      "location": {
        "latitude": 30.0500,
        "longitude": 31.2400
      }
    },
    "navigation": {
      "currentLocation": {
        "latitude": 30.0444,
        "longitude": 31.2357
      },
      "destination": {
        "latitude": 30.0500,
        "longitude": 31.2400
      },
      "distance": 850,
      "distanceText": "850 meters",
      "estimatedTime": "2 min"
    }
  }
}
```

---

## 4.4 Filter by Budget with Location
Filter places by budget with distance sorting.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/budget/filter-with-location` | No |

**Request Body:**
```json
{
  "budget": 1000,
  "currentLocation": {
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "maxDistance": 10000
}
```

**Response:**
```json
{
  "success": true,
  "budget": 1000,
  "currentLocation": {
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "data": {
    "categories": [
      {
        "_id": "...",
        "nameEn": "restaurants",
        "places": [
          {
            "_id": "...",
            "name": "Nearby Cafe",
            "price": 300,
            "distance": 500,
            "distanceText": "500m"
          },
          {
            "_id": "...",
            "name": "Far Restaurant",
            "price": 800,
            "distance": 2500,
            "distanceText": "2.5km"
          }
        ]
      }
    ],
    "totalPlaces": 10,
    "totalCategories": 3
  }
}
```

---

## 4.5 Get Free Places
Get all places with no price (free entry).

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/budget/free-places` | No |

**Query Parameters:**
- `currentLatitude` (optional): User's latitude for distance
- `currentLongitude` (optional): User's longitude for distance
- `categorySlug` (optional): Filter by category

**Example:** `/api/budget/free-places?currentLatitude=30.0444&currentLongitude=31.2357`

**Response:**
```json
{
  "success": true,
  "message": "Found 12 free places",
  "data": {
    "categories": [
      {
        "_id": "...",
        "nameEn": "parks",
        "places": [
          {
            "_id": "...",
            "name": "Al-Azhar Park",
            "price": 0,
            "isFree": true,
            "distance": 1500,
            "distanceText": "1.5km"
          }
        ]
      }
    ],
    "totalPlaces": 12,
    "totalCategories": 3
  }
}
```

---

## 4.6 Get Map Places
Get places with locations for map display.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/budget/map-places` | No |

**Query Parameters:**
- `centerLatitude` (optional): Center point latitude
- `centerLongitude` (optional): Center point longitude
- `radius` (optional): Radius in meters from center
- `categorySlug` (optional): Filter by category
- `minPrice` (optional): Minimum price filter
- `maxPrice` (optional): Maximum price filter
- `limit` (optional): Max number of results (default 100)

**Example:** `/api/budget/map-places?centerLatitude=30.0444&centerLongitude=31.2357&radius=5000`

**Response:**
```json
{
  "success": true,
  "message": "Found 25 places for map",
  "data": {
    "places": [
      {
        "_id": "...",
        "name": "Coffee Shop",
        "price": 200,
        "isFree": false,
        "category": {
          "_id": "...",
          "nameEn": "cafes",
          "icon": "cafe_icon",
          "color": "#8B4513"
        },
        "address": "...",
        "rating": 4.5,
        "image": "https://...",
        "marker": {
          "latitude": 30.0500,
          "longitude": 31.2400
        },
        "distance": 800,
        "distanceText": "800m"
      }
    ],
    "totalPlaces": 25,
    "bounds": {
      "minLat": 30.0300,
      "maxLat": 30.0600,
      "minLng": 31.2200,
      "maxLng": 31.2500
    }
  }
}
```

---

## 4.7 Get Nearby Places
Get places near user's current location with time estimates.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/budget/nearby-places` | No |

**Request Body:**
```json
{
  "currentLocation": {
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "radius": 5000,
  "categorySlug": "restaurants",
  "maxPrice": 500,
  "limit": 50
}
```

**Response:**
```json
{
  "success": true,
  "message": "Found 15 nearby places",
  "searchRadius": 5000,
  "currentLocation": {
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "data": {
    "places": [
      {
        "_id": "...",
        "name": "Nearby Cafe",
        "price": 150,
        "isFree": false,
        "category": {...},
        "address": "...",
        "rating": 4.2,
        "image": "https://...",
        "location": {
          "latitude": 30.0450,
          "longitude": 31.2360
        },
        "distance": 250,
        "distanceText": "250m",
        "estimatedTime": {
          "walking": "3 min walk",
          "driving": "< 1 min drive"
        }
      }
    ],
    "totalPlaces": 15
  }
}
```

---

# 5. ENGAGEMENTS & TIMETABLE APIs

## 5.1 Create Engagement
Create a new engagement with time table.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/engagements` | Yes |

**Request Body:**
```json
{
  "title": "Weekend Outing",
  "date": "2025-01-25",
  "totalBudget": 2000,
  "notes": "Fun day with friends",
  "timeTable": [
    {
      "place": "64a5b8c9d2e4f123456789a0",
      "placeName": "Coffee Shop",
      "startTime": "09:00",
      "endTime": "11:00",
      "duration": 120,
      "estimatedCost": 200,
      "notes": "Breakfast"
    },
    {
      "place": "64a5b8c9d2e4f123456789a1",
      "placeName": "Museum",
      "startTime": "12:00",
      "endTime": "15:00",
      "duration": 180,
      "estimatedCost": 300
    }
  ],
  "captainService": {
    "isRequested": false
  },
  "participants": [
    {
      "name": "Ahmed",
      "phone": "01012345678",
      "status": "accepted"
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Engagement created successfully",
  "data": {
    "engagement": {
      "_id": "64a5b8c9d2e4f123456789b0",
      "title": "Weekend Outing",
      "date": "2025-01-25T00:00:00.000Z",
      "status": "planned",
      "timeTable": [...],
      "captainService": {...},
      "liveLocationSharing": {...},
      "proximityNotifications": {...}
    }
  }
}
```

---

## 5.2 Get User Engagements
Get all user's engagements.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/engagements` | Yes |

**Query Parameters:**
- `status` (optional): Filter by status (planned, in-progress, completed, cancelled)
- `upcoming` (optional): true/false for upcoming only

**Example:** `/api/engagements?upcoming=true&status=planned`

---

## 5.3 Get Engagement by ID
Get specific engagement details.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/engagements/:engagementId` | Yes |

---

## 5.4 Update Engagement Status
Update engagement status.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/engagements/:engagementId/status` | Yes |

**Request Body:**
```json
{
  "status": "in-progress"
}
```

**Status Options:** `planned`, `in-progress`, `completed`, `cancelled`

---

## 5.5 Request Captain Service
Request a driver to transport to first location.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/engagements/:engagementId/request-captain` | Yes |

**Request Body:**
```json
{
  "pickupLocation": {
    "address": "123 Main Street, Cairo",
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "pickupTime": "09:00",
  "estimatedFare": 150
}
```

---

## 5.6 Assign Captain
Assign a specific captain (admin/captain app).

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/engagements/:engagementId/assign-captain` | Yes |

**Request Body:**
```json
{
  "captainId": "64a5b8c9d2e4f123456789c0"
}
```

---

## 5.7 Update Live Location
Enable live location sharing with friends.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/engagements/:engagementId/live-location` | Yes |

**Request Body:**
```json
{
  "isEnabled": true,
  "latitude": 30.0444,
  "longitude": 31.2357,
  "sharedWith": [
    {
      "name": "Ahmed",
      "phone": "01012345678",
      "canEdit": false
    }
  ]
}
```

---

## 5.8 Check Proximity Notifications
Check if user is near any place and send notification.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/engagements/:engagementId/check-proximity` | Yes |

**Request Body:**
```json
{
  "currentLatitude": 30.0444,
  "currentLongitude": 31.2357
}
```

**Response:**
```json
{
  "success": true,
  "message": "Proximity notifications sent",
  "data": {
    "notifications": [
      {
        "place": {
          "_id": "...",
          "name": "Coffee Shop",
          "address": "..."
        },
        "distance": 450,
        "message": "You are 450m away from Coffee Shop"
      }
    ]
  }
}
```

---

# 6. AI PLANS APIs

## 6.1 Create Plan
Create a new AI-generated plan.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/plans` | Yes |

**Request Body:**
```json
{
  "destination": "Cairo",
  "duration": 3,
  "budget": 5000,
  "interests": ["history", "food", "shopping"],
  "travelers": 2
}
```

---

## 6.2 Get User Plans
Get all user's plans.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/plans` | Yes |

---

## 6.3 Get Plan Status
Get plan generation status (for polling).

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/plans/:planId/status` | Yes |

**Response:**
```json
{
  "success": true,
  "data": {
    "status": "completed",
    "progress": 100
  }
}
```

**Status Options:** `generating`, `completed`, `failed`

---

## 6.4 Get Plan by ID
Get specific plan details.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/plans/:planId` | Yes |

---

## 6.5 Toggle Save Plan
Save or unsave a plan.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/plans/:planId/save` | Yes |

---

## 6.6 Delete Plan
Delete a plan.

| Method | Endpoint | Auth |
|--------|----------|------|
| DELETE | `/api/plans/:planId` | Yes |

---

## 6.7 Regenerate Plan
Regenerate a plan with new preferences.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/plans/:planId/regenerate` | Yes |

**Request Body:**
```json
{
  "preferences": "Include more outdoor activities"
}
```

---

# 7. AI CONVERSATIONS APIs

## 7.1 Create Conversation
Create a new AI conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/ai-conversations` | Yes |

**Request Body:**
```json
{
  "title": "Travel Planning Help",
  "initialMessage": "I need help planning a trip to Alexandria"
}
```

---

## 7.2 Get User Conversations
Get all user's AI conversations.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/ai-conversations` | Yes |

---

## 7.3 Get Conversation by ID
Get specific conversation details.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/ai-conversations/:conversationId` | Yes |

---

## 7.4 Send Message to AI
Send a message in a conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/ai-conversations/:conversationId/message` | Yes |

**Request Body:**
```json
{
  "message": "What are the best places to visit in Alexandria?"
}
```

---

## 7.5 Pin Conversation
Pin or unpin a conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/ai-conversations/:conversationId/pin` | Yes |

---

## 7.6 Archive Conversation
Archive or unarchive a conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/ai-conversations/:conversationId/archive` | Yes |

---

## 7.7 Update Conversation Title
Update conversation title.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/ai-conversations/:conversationId/title` | Yes |

**Request Body:**
```json
{
  "title": "Alexandria Trip Planning"
}
```

---

## 7.8 Clear Conversation
Clear all messages in a conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/ai-conversations/:conversationId/clear` | Yes |

---

## 7.9 Delete Conversation
Delete a conversation.

| Method | Endpoint | Auth |
|--------|----------|------|
| DELETE | `/api/ai-conversations/:conversationId` | Yes |

---

# 8. CHAT APIs

## 8.1 Create Chat
Create a new chat.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/chats` | Yes |

**Request Body:**
```json
{
  "recipientId": "64a5b8c9d2e4f1234567890b",
  "type": "direct"
}
```

---

## 8.2 Get User Chats
Get all chats for user.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/chats` | Yes |

---

## 8.3 Get Technical Support Chat
Get or create technical support chat.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/chats/technical-support` | Yes |

---

## 8.4 Get Chat by ID
Get specific chat details.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/chats/:chatId` | Yes |

---

## 8.5 Connect to Chat
Connect to a chat.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/chats/:chatId/connect` | Yes |

---

## 8.6 Get Chat Messages
Get messages for a chat.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/chats/:chatId/messages` | Yes |

---

## 8.7 Send Message
Send a message in a chat.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/chats/:chatId/messages` | Yes |

**Request Body:**
```json
{
  "text": "Hello! How can I help you today?",
  "type": "text"
}
```

---

## 8.8 Mark Messages as Read
Mark all messages in a chat as read.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/chats/:chatId/read` | Yes |

---

## 8.9 Delete Message
Delete a specific message.

| Method | Endpoint | Auth |
|--------|----------|------|
| DELETE | `/api/chats/messages/:messageId` | Yes |

---

# 9. BOOKINGS APIs

## 9.1 Create Booking
Create a new booking.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/bookings/create` | No |

**Request Body:**
```json
{
  "placeId": "64a5b8c9d2e4f123456789a0",
  "userId": "64a5b8c9d2e4f1234567890b",
  "date": "2025-01-25",
  "time": "19:00",
  "numberOfGuests": 4,
  "specialRequests": "Window seat preferred"
}
```

---

## 9.2 Update Booking Status
Update booking status.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/bookings/:id/status` | No |

**Request Body:**
```json
{
  "status": "confirmed"
}
```

**Status Options:** `pending`, `confirmed`, `cancelled`, `completed`

---

# 10. OFFERS APIs

## 10.1 Create Offer
Create a new offer (owners only).

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/offers/create` | Yes |

**Request Body:**
```json
{
  "title": "Weekend Special",
  "description": "Get 25% off on all meals this weekend",
  "discountPercentage": 25,
  "validFrom": "2025-01-20T00:00:00Z",
  "validTo": "2025-01-22T23:59:59Z",
  "image": "https://example.com/offer.jpg"
}
```

---

# 11. OWNER MANAGEMENT APIs

## 11.1 Get Owner Dashboard
Get owner dashboard data.

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/owner/dashboard` | Yes (Owner) |

---

## 11.2 Update Place Info
Update owner's place information.

| Method | Endpoint | Auth |
|--------|----------|------|
| PUT | `/api/owner/place` | Yes (Owner) |

**Request Body:**
```json
{
  "placeName": "Sunset Cafe & Restaurant",
  "placeType": "restaurant",
  "placeAddress": "456 New Street, Cairo",
  "placePhone": "0225559876"
}
```

---

## 11.3 Add Menu Category
Add a new menu category.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/owner/menu/category` | Yes (Owner) |

**Request Body:**
```json
{
  "name": "Main Dishes",
  "description": "Delicious main course items",
  "displayOrder": 1
}
```

---

## 11.4 Add Menu Item
Add a new menu item.

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/owner/menu/item` | Yes (Owner) |

**Request Body:**
```json
{
  "categoryId": "64a5b8c9d2e4f1234567890a",
  "name": "Grilled Chicken",
  "description": "Tender grilled chicken with special sauce",
  "price": 85.50,
  "image": "https://example.com/chicken.jpg",
  "available": true
}
```

---

# ERROR RESPONSES

All APIs return errors in this format:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message (in development only)"
}
```

## Common HTTP Status Codes:

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - No token or invalid token |
| 403 | Forbidden - No permission |
| 404 | Not Found |
| 500 | Server Error |

---

# DATA MODELS

## User Model
```json
{
  "_id": "ObjectId",
  "name": "String",
  "email": "String",
  "phone": "String",
  "avatar": "String (URL)",
  "role": "String (user/owner/admin)",
  "isVerified": "Boolean",
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

## Place Model
```json
{
  "_id": "ObjectId",
  "name": "String",
  "category": "ObjectId (ref: Category)",
  "categorySlug": "String",
  "price": "Number",
  "priceRange": "Number (1-5)",
  "address": "String",
  "city": "String",
  "phone": "String",
  "description": "String",
  "images": ["String (URLs)"],
  "rating": "Number (0-5)",
  "ratingCount": "Number",
  "location": {
    "latitude": "Number",
    "longitude": "Number"
  },
  "workingHours": {
    "open": "String (HH:MM)",
    "close": "String (HH:MM)",
    "days": ["String"]
  },
  "features": ["String"],
  "isActive": "Boolean",
  "isVerified": "Boolean"
}
```

## Category Model
```json
{
  "_id": "ObjectId",
  "nameAr": "String",
  "nameEn": "String",
  "slug": "String",
  "icon": "String",
  "image": "String (URL)",
  "color": "String (hex)",
  "description": "String",
  "order": "Number",
  "isActive": "Boolean",
  "placeCount": "Number"
}
```

## Engagement Model
```json
{
  "_id": "ObjectId",
  "user": "ObjectId (ref: User)",
  "plan": "ObjectId (ref: Plan)",
  "title": "String",
  "date": "Date",
  "timeTable": [{
    "place": "ObjectId (ref: Place)",
    "placeName": "String",
    "startTime": "String (HH:MM)",
    "endTime": "String (HH:MM)",
    "duration": "Number (minutes)",
    "notes": "String",
    "order": "Number",
    "estimatedCost": "Number",
    "status": "String (pending/confirmed/completed/cancelled/skipped)"
  }],
  "captainService": {
    "isRequested": "Boolean",
    "captain": "ObjectId (ref: Captain)",
    "pickupLocation": {
      "address": "String",
      "latitude": "Number",
      "longitude": "Number"
    },
    "pickupTime": "String",
    "captainStatus": "String",
    "estimatedFare": "Number"
  },
  "liveLocationSharing": {
    "isEnabled": "Boolean",
    "sharedWith": [{
      "user": "ObjectId",
      "name": "String",
      "phone": "String"
    }],
    "currentLocation": {
      "latitude": "Number",
      "longitude": "Number",
      "lastUpdated": "Date"
    }
  },
  "proximityNotifications": {
    "isEnabled": "Boolean",
    "notificationRadius": "Number (meters)"
  },
  "participants": [{
    "user": "ObjectId",
    "name": "String",
    "phone": "String",
    "status": "String (invited/accepted/declined/maybe)"
  }],
  "totalBudget": "Number",
  "actualSpent": "Number",
  "status": "String (planned/in-progress/completed/cancelled)"
}
```

---

# FLUTTER INTEGRATION TIPS

## 1. HTTP Client Setup
```dart
// Use dio or http package
final dio = Dio(BaseOptions(
  baseUrl: 'http://localhost:5000',
  headers: {
    'Content-Type': 'application/json',
  },
));

// Add auth interceptor
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    final token = storage.read('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  },
));
```

## 2. Location Services
```dart
// Use geolocator package for getting current location
Position position = await Geolocator.getCurrentPosition();
final currentLocation = {
  'latitude': position.latitude,
  'longitude': position.longitude,
};
```

## 3. Real-time Location Updates
```dart
// For live location sharing, poll the server periodically
Timer.periodic(Duration(seconds: 10), (timer) {
  updateLiveLocation(engagementId, currentLocation);
});
```

## 4. Proximity Notifications
```dart
// Call check-proximity API when location changes
Geolocator.getPositionStream().listen((position) {
  checkProximity(engagementId, position.latitude, position.longitude);
});
```

---

**Document Version:** 1.0
**Last Updated:** 2025-01-21
**API Version:** v1
