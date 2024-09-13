package main

import (
	"fmt"
	"main/handlers"
	"net/http"
)

func main() {
	// TODO: some code goes here
	// Fill out the HomeHandler function in handlers/handlers.go which handles the user's GET request.
	// Start an http server using http.ListenAndServe that handles requests using HomeHandler.
	// "Hello, World!" should be printed to the console when the server starts.

	http.HandleFunc("/", handlers.HomeHandler)
	fmt.Println("Hello, World!")
	http.ListenAndServe(":8080", nil)

}
