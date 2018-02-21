# MLApp Demo
This app build off of the [Core ML Demo](https://github.com/mrmcgrewx/DemoApp) that Apple provides on their developer website.
I just wanted to play around with the Swift Core ML library and get an understanding of how one
may incorporate machine-learning into their application.

The application itself is pretty straightforward. After logging into the app ([I provide a java server here](https://github.com/mrmcgrewx/Basic-Java-Spring-Boot-Server)),
the user can select to start scanning objects or review previous images collected. If the object being scanned by the camera returns
a confidence higher than 50% an image is captured and the option to send the data to the server is presented. You can also review the previous images taken in the review section.

For a breakdown of what's going on in the application [click here](https://filler.com)
