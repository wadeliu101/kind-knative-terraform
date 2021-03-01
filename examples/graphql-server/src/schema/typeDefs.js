const { gql } = require('apollo-server');

const typeDefs = gql`

directive @auth(
  requires: Role = ADMIN,
) on OBJECT | FIELD_DEFINITION

enum Role {
  ADMIN
  REVIEWER
  USER
  UNKNOWN
}

type Payment {
  customer: Customer!
  checkNumber: String!
  paymentDate: String!
  amount: Float!
}

type Customer {
  customerNumber: Int!
  customerName: String!
  contactLastName: String!
  contactFirstName: String!
  phone: String!
  addressLine1: String!
  addressLine2: String
  city: String!
  state: String
  postalCode: String
  country: String!
  salesRepEmployeeNumber: Int
  creditLimit: Float
}

input Login {
  username: String!
  password: String!
}

type Query {
  payments: [Payment!]!
  customers: [Customer!]!
  customer(customerNumber: ID!): Customer!
  login(input: Login!): String!
}

input CustomerUpdate {
  customerName: String
  contactLastName: String
  contactFirstName: String
  phone: String
  addressLine1: String
  addressLine2: String
  city: String
  state: String
  postalCode: String
  country: String
  salesRepEmployeeNumber: Int
  creditLimit: Float
}

type Mutation {
  updateCustomer(customerNumber: ID!, input: CustomerUpdate!): Customer!
  deletePayment(checkNumber: String!): Boolean! @auth(requires: ADMIN)
}
`;

module.exports = typeDefs