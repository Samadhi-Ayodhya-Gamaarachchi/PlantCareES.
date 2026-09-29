# 🌱 PlantCareES

## Home Garden Plant Stress Diagnosis and Care Recommendation Expert System

PlantCareES is a rule-based Expert System developed using **SWI-Prolog**.

The system helps home gardeners identify common plant problems based on observable symptoms. The user selects the symptoms visible on the plant, and the system analyzes them using predefined facts and rules to provide a likely diagnosis, explanation, and care recommendation.

A simple web interface developed using **HTML, CSS, and JavaScript** allows users to interact with the Prolog Expert System easily.

---

## 1. Main Features

- Plant problem diagnosis based on observed symptoms
- Rule-based knowledge representation using Prolog
- Backward chaining for plant problem diagnosis
- Forward chaining for deriving new facts
- Explanation for identified plant problems
- Care recommendations for identified problems
- Simple and user-friendly web interface
- Symptoms organized into meaningful categories
- Communication between the frontend and Prolog using JSON

---

## 2. Problems Covered by the System

The current knowledge base can identify the following plant problems:

### Water Problems
- Overwatering
- Underwatering

### Soil Problems
- Poor Drainage

### Environmental Problems
- Insufficient Light
- Excessive Sunlight

### Nutrient Problems
- Nitrogen Deficiency
- Potassium Deficiency

### Pest Problems
- Aphids
- Spider Mites

### Disease Problems
- Powdery Mildew

---

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| SWI-Prolog | Knowledge base and inference engine |
| SWI-Prolog HTTP Libraries | Local web server and API |
| HTML5 | Web interface structure |
| CSS3 | User interface styling |
| JavaScript | Frontend interaction and communication with Prolog |
| JSON | Data exchange between the frontend and Prolog |

---

## 4. Project Structure

```text
PlantCareES/
│
├── plant_expert.pl
├── server.pl
├── README.md
│
└── frontend/
    ├── index.html
    ├── style.css
    └── script.js
```

### `plant_expert.pl`

Contains the main Expert System, including:

- Problem categories
- Problem descriptions
- Diagnostic rules
- Explanation rules
- Recommendations
- Backward-chaining rules
- Forward-chaining rules
- Observed and inferred facts
- Symptom management

### `server.pl`

Connects the web interface with the Prolog Expert System.

It is responsible for:

- Starting the local web server
- Serving the frontend files
- Receiving selected symptoms from the frontend
- Adding symptoms to the Prolog knowledge base
- Running the diagnosis
- Returning diagnosis results as JSON

### `frontend/index.html`

Contains the structure of the web interface and symptom selection form.

### `frontend/style.css`

Contains the styles used to create the user-friendly PlantCareES interface.

### `frontend/script.js`

Handles frontend functionality, including:

- Collecting selected symptoms
- Sending symptoms to the Prolog server
- Receiving diagnosis results
- Displaying the results
- Clearing selected symptoms and previous results

---

## 5. System Architecture

The basic flow of PlantCareES is:

```text
User
  ↓
Web Interface
  ↓
JavaScript
  ↓
Prolog HTTP Server
  ↓
Expert System Knowledge Base
  ↓
Inference / Rule Matching
  ↓
Diagnosis
  ↓
Explanation and Recommendation
  ↓
Result Displayed to User
```

The frontend collects the symptoms selected by the user and sends them to the Prolog server. The server adds the symptoms as observed facts and uses the Expert System rules to determine likely plant problems.

---

## 6. Knowledge Representation

PlantCareES represents expert knowledge using **Prolog facts and rules**.

### Example Problem Category

```prolog
category(aphids, pest_problem).
```

### Example Description

```prolog
description(aphids,
    'Sap-feeding aphids may be affecting the plant.').
```

### Example Diagnostic Rule

```prolog
likely_problem(aphids) :-
    observed(curled_leaves),
    observed(sticky_leaves).
```

### Example Recommendation

```prolog
recommendation(aphids,
    'Inspect new growth and leaf undersides and use an appropriate aphid management method.').
```

The `observed/1` predicate represents symptoms provided by the user, while `inferred/1` is used to store facts generated through forward chaining.

---

## 7. Backward Chaining

Backward chaining is used for the main plant diagnosis.

The system starts with a possible diagnosis and checks whether the required observed symptoms are available to support that diagnosis.

For example:

```prolog
likely_problem(aphids) :-
    observed(curled_leaves),
    observed(sticky_leaves).
```

The reasoning can be understood as:

```text
Possible Goal: Aphids
        ↓
Are curled leaves observed?
        ↓
Are sticky leaves observed?
        ↓
       Yes
        ↓
Aphids is a likely problem
```

The web-based diagnosis uses the `likely_problem/1` rules to find plant problems that match the symptoms selected by the user.

---

## 8. Forward Chaining

PlantCareES also implements forward chaining.

Forward chaining starts with known facts and applies rules to derive new facts.

For example:

```prolog
forward_rule :-
    observed(curled_leaves),
    observed(sticky_leaves),
    \+ inferred(aphid_signs),
    assertz(inferred(aphid_signs)).
```

Another rule can then use the newly inferred fact:

```prolog
forward_rule :-
    inferred(aphid_signs),
    observed(small_insects),
    \+ inferred(aphids),
    assertz(inferred(aphids)).
```

Therefore, the reasoning process is:

```text
Curled Leaves + Sticky Leaves
             ↓
       Aphid Signs
             ↓
  + Small Insects
             ↓
           Aphids
```

The `forward_chain/0` predicate repeatedly applies forward rules until no additional facts can be inferred.

The current forward-chaining rules demonstrate reasoning for selected problems such as:

- Aphids
- Spider Mites
- Overwatering
- Underwatering
- Powdery Mildew

---

## 9. How to Run the System

### Requirement

Install **SWI-Prolog** before running the project.

### Step 1 - Open the Project

Open the `PlantCareES` project folder.

### Step 2 - Open SWI-Prolog

Start SWI-Prolog and make sure the working directory is the `PlantCareES` project directory.

### Step 3 - Load the Server

Run:

```prolog
?- consult('server.pl').
```

If the file loads correctly, Prolog should return:

```text
true.
```

### Step 4 - Start the Server

Run:

```prolog
?- start_server.
```

The server should start on port `8080`.

### Step 5 - Open the Application

Open a web browser and enter:

```text
http://localhost:8080/
```

Do not open `frontend/index.html` directly because the frontend communicates with the Prolog server.

### Step 6 - Diagnose the Plant

1. Select the symptoms observed on the plant.
2. Click **Diagnose Plant**.
3. The Expert System analyzes the selected symptoms.
4. The diagnosis is displayed with:
   - Problem name
   - Problem category
   - Description
   - Reasoning
   - Recommendation

---

## 10. Example Diagnosis

For example, select:

```text
Curled Leaves
Sticky Leaves
Small Insects Visible
```

Then click **Diagnose Plant**.

The system can return:

```text
Aphids

Category:
Pest Problem

What it is:
Sap-feeding aphids may be affecting the plant.

Why we think so:
Curled or sticky leaves together with small insects
are signs consistent with aphid activity.

What to do:
Inspect new growth and leaf undersides and use an
appropriate aphid management method.
```

---

## 11. Testing Backward Chaining in Prolog

The diagnosis can also be tested directly from the SWI-Prolog console.

First clear the previous case:

```prolog
?- clear_case.
```

Add symptoms:

```prolog
?- add_symptom(curled_leaves).
?- add_symptom(sticky_leaves).
?- add_symptom(small_insects).
```

Run the diagnosis:

```prolog
?- diagnose.
```

The system should identify **aphids** as a likely problem.

---

## 12. Testing Forward Chaining in Prolog

Clear the previous case:

```prolog
?- clear_case.
```

Add the symptoms:

```prolog
?- add_symptom(curled_leaves).
?- add_symptom(sticky_leaves).
?- add_symptom(small_insects).
```

Run:

```prolog
?- show_forward_results.
```

The forward-chaining process can infer:

```text
aphid_signs
aphids
```

This demonstrates how the system starts from observed symptoms and derives new facts.

---

## 13. Example Test Cases

### Aphids

Symptoms:

```text
Curled Leaves
Sticky Leaves
Small Insects Visible
```

Expected diagnosis:

```text
Aphids
```

### Spider Mites

Symptoms:

```text
Fine Webbing
Yellow Speckling
```

Expected diagnosis:

```text
Spider Mites
```

### Overwatering

Symptoms:

```text
Yellow Leaves
Wet Soil
```

Expected diagnosis:

```text
Overwatering
```

### Underwatering

Symptoms:

```text
Dry Soil
Wilting
```

Expected diagnosis:

```text
Underwatering
```

### Powdery Mildew

Symptoms:

```text
White Powder on Leaves
Leaf Surface Affected
```

Expected diagnosis:

```text
Powdery Mildew
```

---

## 14. Explanation Facility

PlantCareES provides an explanation for each diagnosis.

For example:

```prolog
explanation(aphids,
    'Curled or sticky leaves together with small insects are signs consistent with aphid activity.').
```

This helps the user understand why the Expert System selected a particular plant problem instead of displaying only the final diagnosis.

---

## 15. Limitations

The current version has several limitations:

- The knowledge base covers a selected set of common home-garden plant problems.
- Diagnosis depends on symptoms manually selected by the user.
- Different plant problems may have similar symptoms.
- Forward chaining is implemented for selected problems rather than every problem in the knowledge base.
- The system does not use plant images for diagnosis.
- The system does not provide certainty or confidence values.
- Recommendations are general and may not cover every plant species or growing condition.

---

## 16. Future Improvements

Possible future improvements include:

- Adding more plant diseases and pests
- Adding more plant-specific diagnostic rules
- Extending forward chaining to all supported problems
- Adding certainty factors or confidence levels
- Improving the explanation facility
- Adding image-based symptom recognition
- Adding diagnosis history
- Adding plant-specific care recommendations
- Improving the interface for mobile devices

---

## 17. Conclusion

PlantCareES demonstrates the use of a rule-based Expert System for home-garden plant problem diagnosis.

The system combines a **SWI-Prolog knowledge base and inference mechanisms** with a simple web interface. Backward chaining is used for the main diagnosis, while forward chaining demonstrates how new facts can be derived from observed symptoms.

The system also provides explanations and care recommendations so that users can understand the reasoning behind the diagnosis.
