/************************************************************************
@file GetOutcomes.sql

Copyright 2015 Observational Health Data Sciences and Informatics

This file is part of MethodEvaluation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
************************************************************************/

{DEFAULT @cdm_database = 'CDM4_SIM' } 
{DEFAULT @outcome_database_schema = 'CDM4_SIM' } 
{DEFAULT @outcome_table = 'condition_occurrence' }
{DEFAULT @outcome_concept_ids = '' }
{DEFAULT @outcome_condition_type_concept_ids = '' }
{DEFAULT @first_outcome_only = TRUE }

SELECT exposure.subject_id,
	exposure.cohort_start_date,
	exposure.cohort_definition_id AS exposure_concept_id,
	outcome.outcome_concept_id,
	COUNT(DISTINCT outcome_date) AS y
FROM #cohort_person exposure
INNER JOIN (
{@first_outcome_only} ? {
{@outcome_table == 'condition_occurrence' } ? {
	SELECT condition_concept_id AS outcome_concept_id,
		person_id,
		MIN(condition_start_date) AS outcome_date
	FROM condition_occurrence
	WHERE condition_concept_id IN (@outcome_concept_ids)
	GROUP BY condition_concept_id,
		person_id
	  {@outcome_condition_type_concept_ids} ? {AND condition_type_concept_id IN (@outcome_condition_type_concept_ids}
} : { {@outcome_table == 'condition_era' } ? {
	SELECT condition_concept_id AS outcome_concept_id,
	  person_id,
	  MIN(condition_era_start_date) AS outcome_date
	FROM condition_era
	WHERE condition_concept_id IN (@outcome_concept_ids)
	GROUP BY condition_concept_id,
		person_id
} : {
	SELECT cohort_definition_id AS outcome_concept_id,
	  subject_id AS person_id,
	  MIN(cohort_start_date) AS outcome_date
	FROM @outcome_database_schema.@outcome_table co1
	WHERE cohort_definition_id IN (@outcome_concept_ids)
	GROUP BY cohort_definition_id,
		subject_id
}}
} : {
{@outcome_table == 'condition_occurrence' } ? {
	SELECT condition_concept_id AS outcome_concept_id,
	  person_id,
	  condition_start_date AS outcome_date
	FROM condition_occurrence
	WHERE condition_concept_id IN (@outcome_concept_ids)
	  {@outcome_condition_type_concept_ids} ? {AND condition_type_concept_id IN (@outcome_condition_type_concept_ids}
} : { {@outcome_table == 'condition_era' } ? {
	SELECT condition_concept_id AS outcome_concept_id,
	  person_id,
	  condition_era_start_date AS outcome_date
	FROM condition_era
	WHERE condition_concept_id IN (@outcome_concept_ids)
} : {
	SELECT cohort_definition_id AS outcome_concept_id,
	  subject_id AS person_id,
	  cohort_start_date AS outcome_date
	FROM @outcome_database_schema.@outcome_table co1
	WHERE cohort_definition_id IN (@outcome_concept_ids)
}}
}
) outcome
ON outcome.person_id = exposure.subject_id
	AND outcome_date >= exposure.cohort_start_date
	AND outcome_date <= exposure.cohort_end_date
INNER JOIN #exposure_outcome_pairs exposure_outcome_pairs
ON exposure_outcome_pairs.exposure_concept_id = exposure.cohort_definition_id
AND exposure_outcome_pairs.outcome_concept_id = outcome.outcome_concept_id
GROUP BY exposure.subject_id,
	exposure.cohort_start_date,
	exposure.cohort_definition_id,
	outcome.outcome_concept_id;