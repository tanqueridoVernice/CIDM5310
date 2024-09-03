# SECTION 0: Setup and Variables ----

# Make sure these packages are installed
library("httr")
library("rjson")
library("dplyr")

API_KEY = ""
API_URL = "http://82f061b4-e09a-4b7e-9cb0-e961b539d97c.southcentralus.azurecontainer.io/score"


# SECTION 1: API Request Function ----

inference_request <- function(HighBP, HighChol,CholCheck,BMI,Smoker,Stroke,HeartDiseaseorAttack,PhysActivity,Fruits,Veggies,HvyAlcoholConsump,AnyHealthcare,NoDocbcCost,GenHlth,MentHlth,PhysHlth,DiffWalk,Sex,Age,Education,Income) {
  
  # Bind columns to dataframe
  request_df <- data.frame(HighBP, HighChol,CholCheck,BMI,Smoker,Stroke,HeartDiseaseorAttack,PhysActivity,Fruits,Veggies,HvyAlcoholConsump,AnyHealthcare,NoDocbcCost,GenHlth,MentHlth,PhysHlth,DiffWalk,Sex,Age,Education,Income)
  
  req = list(
    Inputs = list(
      "data"=apply(request_df,1,as.list)
    ),
    GlobalParameters = list(
      'method' = "predict"
    )
  )

  # POST request - send JSON to API
  result <- POST(
    url = API_URL,
    add_headers(.headers = c('Content-Type' = "application/json", 'Authorization' = paste('Bearer', API_KEY, sep=' '))),
    body = enc2utf8(toJSON(req))
  )
  return(result)
}


# SECTION 2: Data preprocessing ----
# Fetch data from Power Query workflow
df <- dataset


# SECTION 3: Get Predictions ----
result <- inference_request(df$HighBP, df$HighChol, df$CholCheck, df$BMI, df$DSmoker, df$Stroke, df$HeartDiseaseorAttack, df$PhysActivity, df$Fruits, df$Veggies, df$HvyAlcoholConsump, df$AnyHealthcare,df$NoDocbcCost,df$GenHlth,df$MentHlth,df$PhysHlth,df$DiffWalk,df$Sex,df$Age,df$Education,df$Income )

# SECTION 4: Data postprocessing ----
result <- unlist(content(result))
df$Diabetes_Pred <- result

# SECTION 5: Format output for Power BI ----
output <- df




