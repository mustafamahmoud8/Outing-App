const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const ownerRoutes = require('./routes/ownerRoutes');
const chatRoutes = require('./routes/chatRoutes');
const planRoutes = require('./routes/planRoutes');
const aiConversationRoutes = require('./routes/aiConversationRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const budgetRoutes = require('./routes/budgetRoutes');
const engagementRoutes = require('./routes/engagementRoutes');
const externalApisRoutes = require('./routes/externalApisRoutes');
const smartPlannerRoutes = require('./routes/smartPlanner');

require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.log(err));

// Routes
app.use('/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use("/api/offers", require("./routes/offerRoutes"));
app.use('/api/owner', ownerRoutes);
app.use('/api/chats', chatRoutes);
app.use('/api/plans', planRoutes);
app.use('/api/ai-conversations', aiConversationRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/budget', budgetRoutes);
app.use('/api/engagements', engagementRoutes);
app.use('/api/smart-planner', smartPlannerRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log('Server running on port ' + PORT));
