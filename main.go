package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Map map[string]any

func main() {
	petNames := Map{
		"cats":   []string{"Lucy", "Ponyo"},
		"geckos": []string{"Roku", "Totoro"},
	}

	jsonBytes, _ := json.Marshal(petNames)
	reader := bytes.NewReader(jsonBytes)

	cfg, err := config.LoadDefaultConfig(context.TODO())

	s3Client := s3.NewFromConfig(cfg, func(o *s3.Options) {
		o.Region = "eu-west-1"
	})

	ctx := context.Background()
	_, err = s3Client.PutObject(ctx, &s3.PutObjectInput{

		Bucket: aws.String("arrakis-source-v1"),
		Key:    aws.String("data/pet_names.json"),
		Body:   reader,
	})

	if err != nil {
		panic(err)
	}

	fmt.Println("Uploaded successfully")
}
