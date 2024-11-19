# Documention

## Instructions to run your code
- I've made the .env file accessible publicly to simplify running the application.
- The application can be run by just running
```bash
  docker-compose up --build
```
- After the containers are up and running, execute the following command to create the Elasticsearch index
```bash
  docker-compose run web rails elasticsearch:create_message_index
```

- I haven't defined volumes for the application so the creating data is not persistent.
- I have put some dummy data in seed for testing purposes.
  

## API Documentation

### 1. Applications

#### `POST /applications`
- **Description**: Creates a new application with a generated token.
- **Response**:
  - **201 Created**: Application created.
  - **422 Unprocessable Entity**: Validation failed.

#### `GET /applications/:token`
- **Description**: Retrieves an application by token.
- **Response**:
  - **200 OK**: Application found.
  - **404 Not Found**: Application not found.

#### `PATCH /applications/:token`
- **Description**: Updates an application by token.
- **Response**:
  - **200 OK**: Application updated.
  - **409 Conflict**: Optimistic locking conflict.
  - **422 Unprocessable Entity**: Validation failed.

---

### 2. Chats

#### `GET /applications/:token/chats`
- **Description**: Retrieves all chats for an application.
- **Response**:
  - **200 OK**: List of chats.

#### `GET /applications/:token/chats/:number`
- **Description**: Retrieves a specific chat by number.
- **Response**:
  - **200 OK**: Chat found.
  - **404 Not Found**: Chat not found.

#### `POST /applications/:token/chats`
- **Description**: Creates a new chat for an application.
- **Response**:
  - **201 Created**: Chat created.
  - **422 Unprocessable Entity**: Validation failed.

---

### 3. Messages

#### `GET /applications/:token/chats/:number/messages`
- **Description**: Retrieves all messages for a specific chat.
- **Response**:
  - **200 OK**: List of messages.

#### `GET /applications/:token/chats/:number/messages/:number`
- **Description**: Retrieves a specific message by number.
- **Response**:
  - **200 OK**: Message found.
  - **404 Not Found**: Message not found.

#### `POST /applications/:token/chats/:number/messages`
- **Description**: Creates a new message in a chat.
- **Response**:
  - **201 Created**: Message created.
  - **422 Unprocessable Entity**: Validation failed.

#### `PATCH /applications/:token/chats/:number/messages/:number`
- **Description**: Updates a specific message in a chat.
- **Response**:
  - **200 OK**: Message updated.
  - **422 Unprocessable Entity**: Validation failed.

---

### 4. Search Messages

#### `GET /applications/:token/chats/:number/messages/search`
- **Description**: Searches for messages in a chat based on a query.
- **Query Parameters**: `query` (string)
- **Response**:
  - **200 OK**: List of matching messages.
  - **404 Not Found**: No matching messages.

---

### Status Codes

- **200 OK**: Request was successful.
- **201 Created**: Resource created successfully.
- **404 Not Found**: Resource not found.
- **422 Unprocessable Entity**: Invalid or missing data.
- **409 Conflict**: Conflict (e.g., optimistic locking).
- **500 Internal Server Error**: Server error.


---
---
## Database Schema and ERD diagram
Database UML diagram : ([draw.io](https://app.diagrams.net/)) https://drive.google.com/file/d/1jtIFEO3A40BzT91NeBY5drYAQhqmfAva/view?usp=sharing
![image](https://github.com/user-attachments/assets/46c76133-e124-4c05-bc23-15ba44685161)

---
---
## Running the application



https://github.com/user-attachments/assets/b88e9e21-5a52-48c2-8ecd-29598eb2951d




