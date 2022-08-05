import controllers from "./controllers"

const controllersRegistration = (application) => {
  Object.keys(controllers).forEach(controllerName => {
    application.register(controllerName, controllers[controllerName])
  })
}

export { controllersRegistration }
