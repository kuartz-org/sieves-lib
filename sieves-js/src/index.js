import controllers from "./controllers"

const controllersRegistration = (application) => {
  Object.values(controllers).forEach(controller => {
    application.register(controller.name, controller)
  })
}

export { controllersRegistration }
