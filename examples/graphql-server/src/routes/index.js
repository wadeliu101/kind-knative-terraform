module.exports =  (router) => {
  router.get('/', async function (ctx, next) {
    ctx.body = 'Hello World';
  })
}
