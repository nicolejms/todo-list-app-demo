import radius as radius

@description('The Radius environment ID. Injected by Radius.')
param environment string

resource todoApp 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todo-list-app-demo'
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todoApp.id
    container: {
      image: 'ghcr.io/nicolejms/todo-list-app-demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      env: {
        MYSQL_HOST: {
          value: db.properties.status.binding.host
        }
        MYSQL_USER: {
          value: db.properties.status.binding.username
        }
        MYSQL_PASSWORD: {
          value: db.properties.status.binding.password
        }
        MYSQL_DB: {
          value: db.properties.status.binding.database
        }
      }
    }
    connections: {
      mysql: {
        source: db.id
      }
    }
  }
}

resource db 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'db'
  properties: {
    application: todoApp.id
    environment: environment
  }
}