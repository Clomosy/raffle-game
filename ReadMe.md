# Raffle Application

## Description

This project includes a Raffle Application where users can participate and determine the winners. The application provides real-time communication and the ability to share the results of the draw via MQTT.

## Usage

Note: Add users who will participate in the draw to the project.

In the application, there should be a user to initiate the draw, a user who is an administrator to stop the draw, and users who will participate in the draw.

The user initiating the draw should start the project on Windows. When the "Start Raffle" button is clicked, the draw will begin.

The user who is the administrator:

  - While the draw is ongoing, can stop the draw with the "Stop Raffle" button.

Raffle Results:

  - When the draw ends, the name of the winner will be displayed on the screens of all users.

### Note : Don't forget to authorize the user who will be the administrator in your project.