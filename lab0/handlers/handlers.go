package handlers

import (
	"encoding/base64"
	"fmt"
	"html/template"
	rdb "main/ridership_db"
	"main/utils"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	// Get the selected chart from the query parameter
	selectedChart := r.URL.Query().Get("line")
	if selectedChart == "" {
		selectedChart = "red"
	}

	// Instantiate ridershipDB
	//var db rdb.RidershipDB = &rdb.CsvRidershipDB{} // CSV version
	var db rdb.RidershipDB = &rdb.SqliteRidershipDB{} // SQLite version

	// Open the RidershipDB
	//err := db.Open("mbta.csv")
	err := db.Open("mbta.sqlite")
	if err != nil {
		// Print the error explanation
		fmt.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer func(db rdb.RidershipDB) {
		err := db.Close()
		if err != nil {
			fmt.Println(err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}(db)

	// Get the chart data from RidershipDB
	ridershipData, err := db.GetRidership(selectedChart)
	if err != nil {
		err := db.Open("../mbta.sqlite")
		if err != nil {
			fmt.Println(err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		ridershipData, err = db.GetRidership(selectedChart)
		if err != nil {
			fmt.Println(err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}

	// Plot the bar chart using utils.GenerateBarChart
	chartBytes, err := utils.GenerateBarChart(ridershipData)
	if err != nil {
		fmt.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	chartBase64 := base64.StdEncoding.EncodeToString(chartBytes)

	// Get path to the HTML template for our web app
	_, currentFilePath, _, _ := runtime.Caller(0)
	templateFile := filepath.Join(filepath.Dir(currentFilePath), "template.html")

	// Read and parse the HTML so we can use it as our web app template
	htmlContent, err := os.ReadFile(templateFile)
	if err != nil {
		fmt.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	tmpl, err := template.New("line").Parse(string(htmlContent))
	if err != nil {
		fmt.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Create a struct to hold the values we want to embed in the HTML
	data := struct {
		Image string
		Chart string
	}{
		Image: chartBase64,
		Chart: selectedChart,
	}

	// Use tmpl.Execute to generate the final HTML output and send it as a response
	err = tmpl.Execute(w, data)
	if err != nil {
		fmt.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
