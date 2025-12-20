/**
 * AI Service
 * Integration with AI API (OpenAI, etc.)
 */

const axios = require('axios');

// =============================
//     Generate Plan with AI
// =============================
const generatePlanWithAI = async (userRequest, budget = null, location = null, categories = [], groupType = null) => {
  try {
    // Prepare the prompt for AI
    let prompt = `أنت مساعد ذكي متخصص في تخطيط الخروجات والرحلات في مصر.
    
الطلب من المستخدم: "${userRequest}"

${budget ? `الميزانية المتاحة: ${budget} جنيه مصري` : ''}
${location ? `الموقع المطلوب: ${location}` : ''}
${categories.length > 0 ? `الفئات المطلوبة: ${categories.join(', ')}` : ''}
${groupType ? `نوع المجموعة: ${groupType}` : ''}

يرجى إنشاء خطة خروجة مفصلة تتضمن:
1. عنوان للخطة
2. وصف عام
3. أماكن مقترحة مع الوصف والعنوان والتكلفة المتوقعة لكل مكان
4. الترتيب الزمني للزيارة
5. التكلفة الإجمالية المتوقعة
6. نصائح إضافية

يرجى الإجابة بالعربية بشكل واضح ومنظم.`;

    // Check if OpenAI API key is configured
    if (!process.env.OPENAI_API_KEY) {
      // If no API key, return a mock response for development
      console.warn('⚠️ OpenAI API key not found. Using mock response.');
      return generateMockPlan(userRequest, budget, location, categories, groupType);
    }

    // Call OpenAI API
    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: process.env.OPENAI_MODEL || 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'أنت مساعد ذكي متخصص في تخطيط الخروجات والرحلات في مصر. أجب دائماً بالعربية بشكل واضح ومنظم.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        max_tokens: 1500,
        temperature: 0.7
      },
      {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const generatedText = response.data.choices[0].message.content;
    const tokensUsed = response.data.usage?.total_tokens || 0;

    return {
      plan: generatedText,
      tokensUsed,
      model: response.data.model || process.env.OPENAI_MODEL || 'gpt-3.5-turbo'
    };

  } catch (error) {
    console.error('AI Service Error:', error.response?.data || error.message);
    
    // Fallback to mock response on error
    if (process.env.NODE_ENV === 'development') {
      console.warn('⚠️ AI API error. Using mock response.');
      return generateMockPlan(userRequest, budget, location, categories, groupType);
    }
    
    throw new Error(error.response?.data?.error?.message || 'AI service error');
  }
};

// =============================
//     Mock Plan Generator (for development/testing)
// =============================
const generateMockPlan = (userRequest, budget, location, categories, groupType) => {
  const mockPlan = `
# خطة خروجة مقترحة

## العنوان
${location || 'مدينة نصر'} - خروجة ${groupType === 'family' ? 'عائلية' : groupType === 'couple' ? 'لثنائي' : 'مميزة'}

## الوصف العام
هذه خطة خروجة مخصصة لك بناءً على طلبك. تم اختيار أفضل الأماكن التي تناسب احتياجاتك وميزانيتك.

## الأماكن المقترحة:

### 1. مطعم ${categories.includes('restaurant') ? 'شهير' : 'رائع'}
- **العنوان:** ${location || 'مدينة نصر'}
- **التكلفة المتوقعة:** ${budget ? Math.round(budget * 0.4) : 200} جنيه
- **الوصف:** مطعم يقدم أطباق لذيذة ومناسبة للعائلات

### 2. ${categories.includes('cafe') ? 'مقهى' : categories.includes('mall') ? 'مول' : 'مكان ترفيهي'}
- **العنوان:** ${location || 'مدينة نصر'}
- **التكلفة المتوقعة:** ${budget ? Math.round(budget * 0.3) : 150} جنيه
- **الوصف:** مكان مناسب للاستمتاع والترفيه

### 3. ${categories.includes('park') || categories.includes('amusement') ? 'حديقة أو ملاهي' : 'مكان إضافي'}
- **العنوان:** ${location || 'مدينة نصر'}
- **التكلفة المتوقعة:** ${budget ? Math.round(budget * 0.3) : 150} جنيه
- **الوصف:** مكان للاستمتاع واللعب

## الترتيب الزمني:
1. 12:00 PM - البداية
2. 12:30 PM - الوصول للمطعم
3. 2:00 PM - الانتقال للمكان التالي
4. 4:00 PM - المكان الثالث
5. 6:00 PM - العودة

## التكلفة الإجمالية المتوقعة:
${budget || 500} جنيه مصري

## نصائح إضافية:
- تأكد من حجز الأماكن مسبقاً
- احمل مبلغ إضافي للطوارئ
- استمتع بوقتك!
  `;

  return {
    plan: mockPlan.trim(),
    tokensUsed: 0,
    model: 'mock-model'
  };
};

// =============================
//     Extract Plan Data (Optional - for structured data)
// =============================
const extractPlanData = (planText, userRequest, budget, location, categories, groupType) => {
  // This is a simple extraction - you can enhance it with AI or regex
  const planData = {
    budget: budget || null,
    location: location || null,
    categories: categories || [],
    groupType: groupType || null,
    places: [],
    totalEstimatedCost: budget || null,
    duration: null
  };

  // Try to extract places from the plan text (simplified)
  const placeRegex = /###?\s*\d+\.\s*([^\n]+)/g;
  let match;
  while ((match = placeRegex.exec(planText)) !== null) {
    planData.places.push({
      name: match[1].trim(),
      type: 'place',
      address: location || '',
      estimatedCost: budget ? Math.round(budget / 3) : null,
      description: ''
    });
  }

  return planData;
};

// =============================
//     Generate Chat Response (for conversations)
// =============================
const generateChatResponse = async (conversationHistory, budget = null, location = null, categories = [], groupType = null) => {
  try {
    // Build system message
    const systemMessage = {
      role: 'system',
      content: 'أنت مساعد ذكي متخصص في تخطيط الخروجات والرحلات في مصر. أجب دائماً بالعربية بشكل واضح ومنظم وودود. إذا كان المستخدم يسأل عن خطة خروجة، قدم خطة مفصلة.'
    };

    // Prepare messages array with system message and history
    const messages = [systemMessage, ...conversationHistory];

    // Add context if provided
    if (budget || location || categories.length > 0 || groupType) {
      let contextMessage = 'المعلومات الإضافية: ';
      if (budget) contextMessage += `الميزانية: ${budget} جنيه. `;
      if (location) contextMessage += `الموقع: ${location}. `;
      if (categories.length > 0) contextMessage += `الفئات: ${categories.join(', ')}. `;
      if (groupType) contextMessage += `نوع المجموعة: ${groupType}. `;
      
      messages.push({
        role: 'system',
        content: contextMessage.trim()
      });
    }

    // Check if OpenAI API key is configured
    if (!process.env.OPENAI_API_KEY) {
      console.warn('⚠️ OpenAI API key not found. Using mock response.');
      return generateMockChatResponse(conversationHistory[conversationHistory.length - 1]?.content || '');
    }

    // Call OpenAI API
    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: process.env.OPENAI_MODEL || 'gpt-3.5-turbo',
        messages: messages,
        max_tokens: 1500,
        temperature: 0.7
      },
      {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const generatedText = response.data.choices[0].message.content;
    const tokensUsed = response.data.usage?.total_tokens || 0;

    // Check if response suggests creating a plan (simple check)
    const shouldCreatePlan = generatedText.includes('خطة') || 
                             generatedText.includes('مقترح') || 
                             generatedText.includes('مكان');

    return {
      response: generatedText,
      tokensUsed,
      model: response.data.model || process.env.OPENAI_MODEL || 'gpt-3.5-turbo',
      shouldCreatePlan
    };

  } catch (error) {
    console.error('AI Chat Service Error:', error.response?.data || error.message);
    
    // Fallback to mock response on error
    if (process.env.NODE_ENV === 'development') {
      console.warn('⚠️ AI API error. Using mock response.');
      return generateMockChatResponse(conversationHistory[conversationHistory.length - 1]?.content || '');
    }
    
    throw new Error(error.response?.data?.error?.message || 'AI chat service error');
  }
};

// =============================
//     Mock Chat Response (for development/testing)
// =============================
const generateMockChatResponse = (userMessage) => {
  const responses = [
    'أهلاً بك! كيف يمكنني مساعدتك في تخطيط خروجة مميزة؟',
    'رائع! يمكنني مساعدتك في إنشاء خطة خروجة مخصصة. هل تفضل إخباري بالميزانية والموقع المفضل؟',
    'بكل سرور! يمكنني اقتراح أماكن رائعة لك. ما نوع الخروجة التي تبحث عنها؟',
    'ممتاز! دعني أساعدك في تخطيط خروجة مثالية. هل لديك ميزانية معينة في الاعتبار؟',
  ];

  const randomResponse = responses[Math.floor(Math.random() * responses.length)];

  return {
    response: randomResponse,
    tokensUsed: 0,
    model: 'mock-model',
    shouldCreatePlan: false
  };
};

module.exports = {
  generatePlanWithAI,
  generateChatResponse,
  generateMockPlan,
  generateMockChatResponse,
  extractPlanData
};

