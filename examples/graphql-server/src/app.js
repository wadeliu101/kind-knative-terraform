const Koa = require('koa')
const Router = require('koa-router')
const app = new Koa()
const router = new Router()

const co = require('co')
const json = require('koa-json')
const onerror = require('koa-onerror')
const bodyparser = require('koa-bodyparser')
const logger = require('koa-logger')
const debug = require('debug')('koa2:server')
const path = require('path')

const config = require('./config')
const routes = require('./routes')

const port = process.env.PORT || config.port

// error handler
onerror(app)

// middlewares
app.use(bodyparser())
  .use(json())
  .use(logger())
  .use(router.routes())
  .use(router.allowedMethods())

// logger
app.use(async (ctx, next) => {
  const start = new Date()
  await next()
  const ms = new Date() - start
  console.log(`${ctx.method} ${ctx.url} - $ms`)
})

routes(router)
app.on('error', function(err, ctx) {
  console.log(err)
  logger.error('server error', err, ctx)
})

const { ApolloServer } = require('apollo-server-koa');
const { typeDefs, resolvers } = require('./schema');

const dataloader = require('./services/dataloader')
const directivies = require('./directivies')

const server = new ApolloServer({
  typeDefs,
  resolvers,
  tracing: true,
  schemaDirectives: {
    ...directivies,
  },
  context: ({ ctx }) => ({
    headers: ctx.headers,
    ...dataloader,
  })
});

server.applyMiddleware({ app });

module.exports = app.listen(config.port, () => {
  console.log(`Listening on http://localhost:${config.port}${server.graphqlPath}`)
})
