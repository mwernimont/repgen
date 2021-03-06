% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-parse.r
\name{parseReportMetadataField}
\alias{parseReportMetadataField}
\title{Parse report metadata field}
\usage{
parseReportMetadataField(reportObject, field, defaultValue = NULL)
}
\arguments{
\item{reportObject}{the object representing the full report JSON}

\item{field}{the field name to read from the metadata}

\item{defaultValue}{the optional default value to return if the
provided field is not found in the report JSON}
}
\description{
Given a full report object and field name, returns the
metadata value for the provided field or returns the default value
if the provided field does not exist in the metadata.
}
