# @file PackageMaintenance.R
#
# Copyright 2016 Observational Health Data Sciences and Informatics
#
# This file is part of MethodEvaluation
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Format and check code
OhdsiRTools::formatRFolder()
OhdsiRTools::checkUsagePackage("MethodEvaluation")
OhdsiRTools::updateCopyrightYearFolder()


# Create manual
shell("rm man/MethodEvaluation.pdf")
shell("R CMD Rd2pdf ./ --output=man/MethodEvaluation.pdf")


# Load reference sets
omopReferenceSet <- read.csv("C:/home/Research/Method eval/OmopRefSet.csv")
names(omopReferenceSet) <- SqlRender::snakeCaseToCamelCase(names(omopReferenceSet))
save(omopReferenceSet, file = "data/omopReferenceSet.rda", compress = "xz")

euadrReferenceSet <- read.csv("C:/home/Research/Method eval/EUADRRefSet.csv")
names(euadrReferenceSet) <- SqlRender::snakeCaseToCamelCase(names(euadrReferenceSet))
save(euadrReferenceSet, file = "data/euadrReferenceSet.rda", compress = "xz")
