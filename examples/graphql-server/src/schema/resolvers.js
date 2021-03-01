const resolvers = {
  Query: {
    payments: () => require('../controller/payment').findAll(),
    customers: () => require('../controller/customer').findAll(),
    customer: (_, args) => require('../controller/customer').findOne(args.customerNumber),
    login: (_, args) => require('../services/auth').login(args.input),
  },
  Mutation: {
    updateCustomer: (_, args) => require('../controller/customer').updateOne(args.customerNumber, args.input),
    deletePayment: (_, args) => require('../controller/payment').deleteOne(args.checkNumber),
  },
  Payment: {
    customer: async (parent, _, context) => await context.customersloader.load(parent.customerNumber),
  }
};

module.exports = resolvers