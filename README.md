
# Aweber - Ruby | API Integration

  

Author: Santiago Vanegas<br/>


This integration comprises the following functions and endpoints:

| Function(Aweber Integration)  | Description  | EndPoint  | Method  | Parameters (Payload) |
|--|--|--|--|--|
| `Contact List`(**&#x2716;**) | Get a list with all contacts registered | `/contacts` | `GET` |  |
| `Create Contact`(**&#x2714;**) | Register a new contact | `/contacts` | `POST` | correo, nombre, telefono, send_information_status (true or false) |
| `Show Contact`(**&#x2716;**) | Show a contact according to `:id` | `/contacts/:id` | `GET` |  |
| `Update Contact`(**&#x2716;**) | Update a contact according to `:id` | `/contacts/:id` | `PUT` | Parameter to update. Except `correo`, since for Aweber the email works as an identifier. |
| `Delete Contact`(**&#x2716;**) | Delete a contact according to `:id` | `/contacts/:id` | `DELETE` |  |  

# Run in local environment
### Prerequisites

To run the integration in a local environment, Ruby on Rails must be installed. It is recommended to follow the following guide for Windows 10: [Guide](https://gorails.com/setup/windows/10). <br/>

Indicate the operating system in the guide, if it isn't Windows 10.

&#x1F53A;**NOTE: To avoid potential compatibility issues, Ruby version 2.7.0 and Rails version 6.0.4 should be installed. The database management system used is Postgresql.** 

## Running Integration
**Note:** It is recommended to use the Ubuntu console.

For the [Final Steps](https://gorails.com/setup/windows/10#final-steps) section of the [Guide](https://gorails.com/setup/windows/10), the following steps should be performed instead:

 #### Clone the repository from GitHub
 
- Create the folder where you want to save the integration: `mkdir name_dir`
- Go to the folder: `cd name_dir`
- Install git: [How to install git](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-20-04-es)
- Run `git init`
- Clone integration from GitHub: `git clone https://github.com/svan95/apiesp-aweber.git`

#### Finals Steps

 - Run `bundle install` or just `bundle`
 - Create a Postgres DB: `rake db:create` 
 - Run the migrations: `rake db:migrate`
 - Run `Rails s`
 - The integration should be running through the following URL: http://localhost:3000/
 - Finally, on another console, run `sidekiq`in the same directory