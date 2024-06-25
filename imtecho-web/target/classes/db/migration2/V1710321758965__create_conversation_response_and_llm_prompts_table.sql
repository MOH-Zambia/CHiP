CREATE TABLE IF NOT EXISTS conversation_response
(
id serial,
remarks text,
created_on timestamp DEFAULT CURRENT_TIMESTAMP NULL,
transcript text,
differential_diagnosis text,
soap_notes text,
audio_string text,
user_id int,
differential_diagnosis_rating text,
subjective_rating text,
objective_rating text,
assessment_rating text,
plan_rating text,
comments text,
differential_diagnosis_token_metadata text,
soap_notes_token_metadata text
);

CREATE TABLE IF NOT EXISTS llm_prompts (
	id serial4,
	code text,
	task text,
	additional_notes text,
	output_format text,
	system_context text,
	json_output bool,
	prompt_version text,
	is_active bool DEFAULT false,
	CONSTRAINT llm_prompts_code_prompt_version_key UNIQUE (code, prompt_version)
);

DELETE FROM llm_prompts where prompt_version = 'v0.1';

INSERT INTO public.llm_prompts VALUES (1, 'HEALTHCONCIOUS', 'Here is the conversation among Doctor and Patient : ##transcribe. Analyse the data thoroughly. Provide recommended exercises/diet for the patient to stay healthy according to the conversation provided. ', '1. Structure the data in a well-explained manner
                2. Use medical language and terminology suitable for a doctor''s assessment.
                3. Avoid referencing generic terms which point towards the patient. Go straight forward to-the point and focus on specific health issues. Give output as if a doctor is recommending exercises/diet to the patient considering the risk involved in the conversation.
                4. Do not include any fabricated information. ', NULL, 'You are an expert at generating optimal Exercise/Diet Plan using the doctor patient conversation transcript provided.
      You provide accurate output only based on the data provided and do not make up things on your own.', false, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (2, 'RECQUESTIONS', 'Generate a single insightful question along with the relevant options associated with the question based on the transcript to facilitate the diagnostic process without outputting the differential diagnosis. The questions should be succinct, not directly address the patient, and aimed at refining the internal differential diagnosis. The conversation between the doctor and patient is as follows : ##transcribe. ', 'Only consider medically relevant information from the transcript for  question generation. Handle all data with utmost confidentiality and compliance with healthcare data regulations. Outputs should be user-friendly and easily interpretable by healthcare professionals. Strictly adhere to the provided format for consistency and reliability in medical contexts. ', 'Output Format:
          {
          Q : Question,
          A : {
            O1 : Option1,
            O2 : Option2,
            O3 : Option3,
            ...
            }
          }
Strictly follow the Output Format as given above.
Return me the output in JSON Format. In the above Output Format, Q stands for the Question, A stands for the Answer list which contains valid and questionable options to the question asked and O1..n stands for the options to the question asked.
', 'You are an expert at predicting recommended questions to ask when you are provided with a conversation between doctor and patient.
      Return the output in JSON Format
      Output Format(Only If no relevant medical Data) :
        {
        "Q" : "No relevant data provided",
        "A" : {}
        }', true, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (3, 'SOAP', 'Here is the conversation among Doctor and Patient : ##transcribe. Analyse the data thoroughly. Generate a concise SOAP (Subjective Objective Assessment Plan) analysis from a doctor''s perspective based on the transcript provided. Do mention diet plans along with the plan.', '1. Structure the analysis into four sections: Subjective, Objective, Assessment, and Plan.
                2. Present each section in bullet-point format ("•").
                3. Use medical language and terminology suitable for a doctor''s assessment.
                4. Avoid referencing generic terms in Subjective like "Patient reports , Patient Experienced".Go straight forward to-the point and focus on specific health issues.
                5. Do not include any fabricated information.
                6. Refrain from suggesting a plan independently. ', 'Output Format:
                Subjective: [Subjetive]
                Objective: [Objective]
                Assessment: [Assessment]
                Plan: [Plan]
		Strictly follow the Output Format as given above.
		And output bullet-wise list for each of the SOAP Note.
', 'You are an expert at generating SOAP(Subjective, Objective, Assessment, and Plan) using the doctor patient conversation transcript provided.
                             You provide accurate output only based on the data provided and do not make up things on your own. You suggest diet plans to the patient according to the disease diagnosed', false, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (4, 'RISK', 'Here is the conversation among Doctor and Patient : ##transcribe. Analyse the data thoroughly. Provide a detailed bullet-wise Risk Analysis of the patient considering the doctor and patient''s conversation. The risk analysis should be succint and to the point. Give output such that it is easily understandable even to the person having limited medical knowledge ', '1. Structure the data in a well-explained manner.
                2. Output a bullet-point format ("•") of the analysis.Each point being clear and easily understandable
                3. Use medical language and terminology suitable for a doctor''s assessment.
                4. Avoid referencing generic terms which point towards the patient. Go straight forward to-the point and focus on specific health issues. Give output as if a doctor is providing the analysis to the patient of the health report.
                5. Do not include any fabricated information. ', NULL, 'You are an expert at generating Risk Analysis using the doctor patient conversation transcript provided.
      You provide accurate output only based on the data provided and do not make up things on your own.', false, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (5, 'DOCTPRESCRIPTION', 'Here is the conversation among Doctor and Patient : ##transcribe. Analyse the data thoroughly. Provide required prescription of the risks involved from the patient''s data. ', '1. Structure the data in a well-explained manner
                2. Use medical language and terminology suitable for a doctor''s assessment.
                3. Avoid referencing generic terms which point towards the patient. Go straight forward to-the point and focus on specific health issues. Give output as if a doctor is prescribing medicines/exercises to the patient considering the risk involved in the conversation.
                4. Do not include any fabricated information. ', NULL, 'You are an expert at generating Doctor Prescription using the doctor patient conversation transcript provided.
      You provide accurate output only based on the data provided and do not make up things on your own.', false, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (6, 'SUMMARY', 'Here is the conversation among Doctor and Patient : ##transcribe. Analyse the data thoroughly. Extract me a 5-6 sentenced summary from the conversation provided. Summary should be succint and to the point covering all the important points discussed in the conversation. ', 'Additional Notes: 1. Structure the data in a well-explained manner
                2. Use medical language and terminology suitable for a doctor''s assessment.
                3. Avoid referencing generic terms which point towards the patient. Go straight forward to-the point and focus on specific health issues. Give output as if a doctor is providing the summary to the patient considering the conversation.
                4. Do not include any fabricated information. ', NULL, 'You are an expert at generating Summary using the doctor patient conversation transcript provided.
      You provide accurate output only based on the data provided and do not make up things on your own.', false, 'v1.0', true);

INSERT INTO public.llm_prompts VALUES (7, 'DIFFDIAGNOSIS', 'Task : Generate a differential diagnosis which should contain 3 diseases, providing potential diagnoses in decreasing order based on the chance of the disease that affect the patient. The diagnoses should be listed such that they ensure specificity and relevance to the medical context. If there is no medical data present in the conversation, output "No relevant data provided" The conversation between the doctor and patient is as follows : ##transcribe.', 'Do consider the transcript provided thorougly and return the diagnosis with some relevant disease predictions even if there is slightest medical symptom associatd with the transcript. Only consider medically relevant information from the transcript for diagnosis. Handle all data with utmost confidentiality and compliance with healthcare data regulations. Outputs should be user-friendly and easily interpretable by healthcare professionals. Strictly adhere to the provided format for consistency and reliability in medical contexts.', 'Output Format:
        {
          "differentialDiagnosis : {
            "mostLikely" : "mostLikelyDisease",
            "likely" : ["likelyDisease1", "likelyDisease2"]
          }
        }
Strictly follow the Output Format as given above.
mostLikelyDisease should contain the name of the most likely disease
likelyDisease1 should contain the name of the second most likely disease
likelyDisease2 should contain the name of the third most likely disease
If there are no medical data present in the conversation return the below format only
      Output Format(Only If no relevant medical Data) :
      {
        "differentialDiagnosis" : "No relevant data provided"
      }', '
You are an expert at predicting differential diagnosis.
      Return the output in valid JSON Format. All the strings generated by you must be enclosed within double quotes
	  ', true, 'v1.0', true);
