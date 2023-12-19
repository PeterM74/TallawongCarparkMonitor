# TallawongCarparkMonitor
![](https://img.shields.io/badge/version-0.1.1-yellow)

Shiny app that monitors the available car spaces at [Tallawong Metro](https://transportnsw.info/routes/details/sydney-metro/m/0300M) car park. It uses the Transport for NSW's [Open Data hub](https://opendata.transport.nsw.gov.au/), specifically the [car park API](https://opendata.transport.nsw.gov.au/dataset/car-park-api).

The app is deployed to shinyapps.io, at https://pmo74.shinyapps.io/TallawongCarparkMonitor/. 

## Getting started
In order to do any development, you will need to request an Open Data hub API key after registering for an account (it is free). Store the key in the `.Renviron` file:

```
usethis::edit_r_environ(scope = "project")
## The above command will open a .Renviron file. On the first line, store the API key:
APIKey="API_KEY_HERE"
```

There are many data points and API calls available, read [the documentation](https://opendata.transport.nsw.gov.au/dataset/car-park-api) to find out more. Install the R packages and you are ready to go! You will need to deploy the Shiny app somewhere, I recommend shinyapps.io as it is free for <25hrs/month use.

## Contributing and getting help
The app is currently under development. When it reaches V1.0, if you encounter a bug or crash, please file an [issue](https://github.com/PeterM74/TallawongCarparkMonitor/issues) with sufficient detail to replicate the bug. You may also submit requests to improve the experience through the `enhancements` tag.

### Updating historical dataset
The historical tab on the app uses data from `2022-11-20` until `2023-12-06`. The app will need to be regularly updated with the latest data. Refer to the [Quarto doc](HistoricalData/HistoricalTallawongData.qmd) for information and code to load the latest data.