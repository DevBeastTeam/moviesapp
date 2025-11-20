# API Endpoints

Base URL: `https://dev.play.e-dutainment.com/api/1.0`

## Authentication
- `POST /auth/token` - Login
- `GET /auth/me` - Get current user info

## Users
- `POST /users/edit` - Edit user profile
- `POST /users/saw-entry-page` - Mark entry page as seen

## Badges
- `GET /badges/list` - List all badges

## Quizzes
- `GET /quizz/categories/list` - List quiz categories
- `GET /quizz/categories/{category}/{type}/list` - List quizzes by category and type
- `GET /quizz/{id}/start` - Start a quiz
- `GET /quizz/{id}/results/{session}` - Get quiz results
- `GET /quizz/entry-quiz` - Get entry quiz
- `GET /quizz/entry-quiz/results` - Get entry quiz results
- `POST /quizz/entry-quiz/save` - Save entry quiz answers
- `POST /quizz/{id}/save` - Save quiz answers

## Movies
- `GET /movies/list` - List movies
- `GET /movies/{id}` - Get movie details
- `GET /movies/{id}/questions` - Get movie questions
- `POST /movies/{id}/history` - Update movie watch history
- `GET /movies/{movieId}/subjects` - Get movie subjects

## Questions
- `GET /questions/random` - Get random question
- `POST /questions/{questionId}/save` - Save question answer

## Search
- `GET /search` - Search with query

## Lessons
- `GET /lessons/grammar` - List grammar lessons ✅
- `GET /lessons/grammar/{id}` - Get grammar lesson details ✅
- `GET /lessons/exercises` - List exercises
- `GET /lessons/exercises/category/{catgRef}` - List exercises by category
- `POST /lessons/exercises/{answerId}` - Submit exercise answer
- `GET /lessons/pronunciation` - List pronunciation lessons
- `GET /lessons/pronunciation/{id}` - Get pronunciation lesson details

## Flashcards
- `GET /flashcard/` - List flashcards
- `GET /flashcard/{subjectId}` - Get flashcards by subject
- `GET /flashcard/view/{movieId}/{levelId}` - View flashcards for movie and level

## AI Chat
- `POST /chat/create` - Create new chat
- `POST /chat/messages/new/{conversationId}` - Send new message
- `GET /chat` - List all chats
- `GET /chat/{chatId}` - Get chat by ID
- `POST /chat/{conversationId}/title` - Update chat title
- `POST /chat/toggle-pin/{conversationId}` - Toggle pin chat
- `DELETE /chat/delete/{conversationId}` - Delete chat