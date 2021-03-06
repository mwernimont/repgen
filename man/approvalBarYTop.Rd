% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-approvals.R
\name{approvalBarYTop}
\alias{approvalBarYTop}
\title{Compute top position of approval bars.}
\usage{
approvalBarYTop(lim, ylog)
}
\arguments{
\item{lim}{The \emph{y}-axis real interval, as two element vector.}

\item{ylog}{A Boolean, indicating whether the \emph{y}-axis is log_10 scale: 
TRUE => log_10; FALSE => linear.}
}
\value{
Approval bar, vertical top extent, in world coordinates.
}
\description{
Compute top position of approval bars.
}
