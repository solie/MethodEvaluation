% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Mdrr.R
\name{filterOnMdrr}
\alias{filterOnMdrr}
\title{Filter data based on MDRR}
\usage{
filterOnMdrr(data, mdrr, threshold = 1.25)
}
\arguments{
\item{data}{A data frame with at least two columns:
\itemize{
  \item {"exposureConceptId" containing the drug_concept_ID or
        cohort_definition_id of the exposure variable}
  \item {"outcomeConceptId" containing the condition_concept_ID or
        cohort_definition_id of the outcome variable}
}}

\item{mdrr}{A data frame as generated by the \code{\link{computeMdrr}} function.}

\item{threshold}{The required minimum detectable relative risk.}
}
\value{
A subset of the data object.
}
\description{
Filters a dataset to those exposure-outcome pairs with sufficient power.
}
