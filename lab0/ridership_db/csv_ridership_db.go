package ridershipDB

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"strconv"
)

type CsvRidershipDB struct {
	idIdxMap      map[string]int
	csvFile       *os.File
	csvReader     *csv.Reader
	num_intervals int
}

func (c *CsvRidershipDB) Open(filePath string) error {
	c.num_intervals = 9

	// Create a map that maps MBTA's time period ids to indexes in the slice
	c.idIdxMap = make(map[string]int)
	for i := 1; i <= c.num_intervals; i++ {
		timePeriodID := fmt.Sprintf("time_period_%02d", i)
		c.idIdxMap[timePeriodID] = i - 1
	}

	// create csv reader
	csvFile, err := os.Open(filePath)
	if err != nil {
		return err
	}
	c.csvFile = csvFile
	c.csvReader = csv.NewReader(c.csvFile)

	return nil
}

func (c *CsvRidershipDB) GetRidership(lineId string) ([]int64, error) {
	// Initialize the result slice with a size equal to the number of intervals
	ridershipData := make([]int64, c.num_intervals)

	// Loop through each record in the CSV file
	for {
		record, err := c.csvReader.Read()
		if err == io.EOF {
			break // Stop reading at the end of the file
		}
		if err != nil {
			return nil, err
		}

		// The first column contains the line ID
		if record[0] != lineId {
			continue // Skip this record if the line ID doesn't match
		}

		// The third column contains the time period
		timePeriod := record[2]

		// The last column contains the ridership data
		ridershipValue, err := strconv.ParseInt(record[4], 10, 64)
		if err != nil {
			return nil, err
		}

		// Find the index for the time period in the slice
		if idx, ok := c.idIdxMap[timePeriod]; ok {
			// Add the ridership value to the existing value (aggregate across all stations)
			ridershipData[idx] += ridershipValue
		}
	}

	return ridershipData, nil
}

func (c *CsvRidershipDB) Close() error {
	if c.csvFile == nil {
		return fmt.Errorf("database not open")
	}

	err := c.csvFile.Close()
	if err != nil {
		return err
	}

	c.csvFile = nil
	c.csvReader = nil
	return nil
}
