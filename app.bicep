import radius as radius

@description('The Radius Application.')
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
  }
}

@description('The Radius Environment ID. Injected automatically by Radius.')
param environment string

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/nicolejms/todo-list-app-demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      env: {
        MONGO_URL: {
          value: 'mongodb://${db.properties.host}:${db.properties.port}/todo'
        }
      }
    }
    connections: {
      mongodb: {
        source: db.id
      }
    }
  }
}

resource db 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'mongodb'
  properties: {
    application: app.id
    environment: environment
  }
}

resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: 'http://frontend:3000'
      }
    ]
  }
}