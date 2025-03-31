# Personal Finance Manager API

A RESTful API service for managing personal finances, built with Ruby on Rails. This API allows users to manage their bank accounts and track transactions.

## Features

- User authentication with JWT
- Bank account management
- Transaction tracking
- Automatic balance updates
- Support for multiple currencies
- Transaction categorization

## Architecture Overview

### Technology Stack
- **Framework**: Ruby on Rails 8.0.2 (API Mode)
- **Database**: PostgreSQL 14
- **Authentication**: JWT (JSON Web Tokens)

### Application Structure
```
finance_manager/
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           ├── base_controller.rb
│   │           ├── auth_controller.rb
│   │           ├── bank_accounts_controller.rb
│   │           └── transactions_controller.rb
│   ├── models/
│   │   ├── user.rb
│   │   ├── bank_account.rb
│   │   └── transaction.rb
│   └── ...
├── config/
│   ├── routes.rb
│   └── database.yml
└── db/
    └── migrate/
```

### Key Components
1. **API Layer**
   - RESTful endpoints with proper versioning
   - JSON request/response format
   - JWT-based authentication
   - Proper error handling and status codes

2. **Service Layer**
   - Business logic encapsulation
   - Transaction management
   - Balance calculations
   - Data validation

3. **Data Layer**
   - PostgreSQL database
   - Active Record ORM
   - Database migrations
   - Model relationships and validations

4. **Security Layer**
   - JWT token authentication
   - Password hashing with bcrypt
   - Input validation
   - Protected routes
   - Error handling

## Database Design

### Entity Relationship Diagram
```
User
  └── has_many :bank_accounts
      └── has_many :transactions
```

### Database Schema

#### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_digest VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
```

#### Bank Accounts Table
```sql
CREATE TABLE bank_accounts (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  name VARCHAR(255) NOT NULL,
  account_type VARCHAR(50) NOT NULL,
  balance DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  CONSTRAINT account_type_check CHECK (account_type IN ('checking', 'savings', 'credit', 'investment'))
);
```

#### Transactions Table
```sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY,
  bank_account_id UUID NOT NULL REFERENCES bank_accounts(id),
  amount DECIMAL(10,2) NOT NULL,
  transaction_type VARCHAR(50) NOT NULL,
  category VARCHAR(255) NOT NULL,
  description TEXT,
  date TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  CONSTRAINT transaction_type_check CHECK (transaction_type IN ('income', 'expense'))
);
```

### Model Relationships

#### User Model
```ruby
class User < ApplicationRecord
  has_secure_password
  has_many :bank_accounts, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
end
```

#### Bank Account Model
```ruby
class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, presence: true, numericality: true
  validates :currency, presence: true
  
  ACCOUNT_TYPES = %w[checking savings credit investment].freeze
  validates :account_type, inclusion: { in: ACCOUNT_TYPES }
end
```

#### Transaction Model
```ruby
class Transaction < ApplicationRecord
  belongs_to :bank_account
  
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true
  validates :category, presence: true
  validates :date, presence: true
  
  TRANSACTION_TYPES = %w[income expense].freeze
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES }
  
  before_save :update_bank_account_balance
end
```

### Database Features
- UUID primary keys for better security and distribution
- Proper foreign key constraints
- Check constraints for enums
- Timestamps for tracking creation and updates
- Decimal precision for monetary values
- Text fields for longer content
- Indexes on frequently queried columns

## Prerequisites

- Ruby 3.4.0 or higher
- PostgreSQL 14 or higher
- Rails 8.0.2

## Setup

1. Clone the repository:
```bash
git clone https://github.com/truongntn/finance_manager
cd finance_manager
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create db:migrate
```

4. Start the server:
```bash
rails server
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Authentication

#### Register a new user
```
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "first_name": "John",
    "last_name": "Doe"
  }
}
```

#### Login
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Bank Accounts

#### List all bank accounts
```
GET /api/v1/bank_accounts
Authorization: Bearer <your_jwt_token>
```

#### Get a specific bank account
```
GET /api/v1/bank_accounts/:id
Authorization: Bearer <your_jwt_token>
```

#### Create a new bank account
```
POST /api/v1/bank_accounts
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "bank_account": {
    "name": "Main Account",
    "account_type": "checking",
    "balance": 1000.00,
    "currency": "USD"
  }
}
```

#### Update a bank account
```
PUT /api/v1/bank_accounts/:id
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "bank_account": {
    "name": "Updated Account Name",
    "balance": 2000.00
  }
}
```

#### Delete a bank account
```
DELETE /api/v1/bank_accounts/:id
Authorization: Bearer <your_jwt_token>
```

### Transactions

#### List all transactions for a bank account
```
GET /api/v1/bank_accounts/:bank_account_id/transactions
Authorization: Bearer <your_jwt_token>
```

#### Get a specific transaction
```
GET /api/v1/bank_accounts/:bank_account_id/transactions/:id
Authorization: Bearer <your_jwt_token>
```

#### Create a new transaction
```
POST /api/v1/bank_accounts/:bank_account_id/transactions
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "transaction": {
    "amount": 100.00,
    "transaction_type": "expense",
    "category": "groceries",
    "description": "Weekly groceries",
    "date": "2024-03-30T10:00:00Z"
  }
}
```

#### Update a transaction
```
PUT /api/v1/bank_accounts/:bank_account_id/transactions/:id
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "transaction": {
    "amount": 150.00,
    "description": "Updated description"
  }
}
```

#### Delete a transaction
```
DELETE /api/v1/bank_accounts/:bank_account_id/transactions/:id
Authorization: Bearer <your_jwt_token>
```

## Data Models

### User
- id: uuid (primary key)
- email: string (unique)
- password_digest: string
- first_name: string
- last_name: string
- created_at: datetime
- updated_at: datetime

### Bank Account
- id: uuid (primary key)
- user_id: uuid (foreign key)
- name: string
- account_type: string (enum: checking, savings, credit, investment)
- balance: decimal
- currency: string
- created_at: datetime
- updated_at: datetime

### Transaction
- id: uuid (primary key)
- bank_account_id: uuid (foreign key)
- amount: decimal
- transaction_type: string (enum: income, expense)
- category: string
- description: text
- date: datetime
- created_at: datetime
- updated_at: datetime

## Security

- JWT-based authentication
- Password hashing with bcrypt
- Protected routes requiring authentication
- Input validation and sanitization
- Proper error handling and status codes
