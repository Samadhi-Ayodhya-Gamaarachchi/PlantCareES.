% ============================================================
% PlantCareES
% Home Garden Plant Stress Diagnosis and Care Recommendation
% Expert System
% ============================================================

:- dynamic observed/1.
:- dynamic inferred/1.


% ============================================================
% SECTION 1 - KNOWLEDGE BASE: FACTS
% ============================================================

% ---------------- Problem Categories ----------------

category(overwatering, water_problem).
category(underwatering, water_problem).
category(poor_drainage, soil_problem).

category(insufficient_light, environmental_problem).
category(excessive_sunlight, environmental_problem).

category(nitrogen_deficiency, nutrient_problem).
category(potassium_deficiency, nutrient_problem).

category(aphids, pest_problem).
category(spider_mites, pest_problem).

category(powdery_mildew, disease_problem).


% ---------------- Problem Descriptions ----------------

description(overwatering,
    'The plant may be receiving too much water.').

description(underwatering,
    'The plant may not be receiving enough water.').

description(poor_drainage,
    'Water may be remaining around the roots for too long.').

description(insufficient_light,
    'The plant may not be receiving enough suitable light.').

description(excessive_sunlight,
    'The plant may be receiving too much direct sunlight or heat.').

description(nitrogen_deficiency,
    'The symptoms may indicate a nitrogen-related nutrient problem.').

description(potassium_deficiency,
    'The symptoms may indicate a potassium-related nutrient problem.').

description(aphids,
    'Sap-feeding aphids may be affecting the plant.').

description(spider_mites,
    'Spider mites may be feeding on the plant leaves.').

description(powdery_mildew,
    'The white powdery growth may indicate powdery mildew.').


% ---------------- Recommendations ----------------

recommendation(overwatering,
    'Reduce watering and allow the soil to dry before watering again.').

recommendation(underwatering,
    'Water the plant thoroughly and maintain a suitable watering schedule.').

recommendation(poor_drainage,
    'Improve soil drainage and avoid allowing water to remain around the roots.').

recommendation(insufficient_light,
    'Move the plant to a location with more suitable light.').

recommendation(excessive_sunlight,
    'Protect the plant from intense direct sunlight and excessive heat.').

recommendation(nitrogen_deficiency,
    'Check soil fertility and consider an appropriate balanced fertilizer.').

recommendation(potassium_deficiency,
    'Check soil nutrients and consider an appropriate potassium source.').

recommendation(aphids,
    'Inspect new growth and leaf undersides and use an appropriate aphid management method.').

recommendation(spider_mites,
    'Inspect leaf undersides for mites and webbing and use an appropriate mite management method.').

recommendation(powdery_mildew,
    'Remove heavily affected material where appropriate and improve airflow around the plant.').


% ============================================================
% SECTION 2 - BACKWARD CHAINING DIAGNOSTIC RULES
% ============================================================

% ---------------- Overwatering ----------------

likely_problem(overwatering) :-
    observed(yellow_leaves),
    observed(wet_soil).

likely_problem(overwatering) :-
    observed(wet_soil),
    observed(wilting).

likely_problem(overwatering) :-
    observed(wet_soil),
    observed(slow_growth).


% ---------------- Underwatering ----------------

likely_problem(underwatering) :-
    observed(dry_soil),
    observed(wilting).

likely_problem(underwatering) :-
    observed(dry_soil),
    observed(dry_leaf_edges).

likely_problem(underwatering) :-
    observed(dry_soil),
    observed(wilting),
    observed(dry_leaf_edges).


% ---------------- Poor Drainage ----------------

likely_problem(poor_drainage) :-
    observed(wet_soil),
    observed(poor_drainage).

likely_problem(poor_drainage) :-
    observed(wet_soil),
    observed(yellow_leaves),
    observed(slow_growth).

likely_problem(poor_drainage) :-
    observed(wet_soil),
    observed(wilting),
    observed(slow_growth).


% ---------------- Insufficient Light ----------------

likely_problem(insufficient_light) :-
    observed(pale_leaves),
    observed(slow_growth),
    observed(low_light).

likely_problem(insufficient_light) :-
    observed(weak_growth),
    observed(low_light).

likely_problem(insufficient_light) :-
    observed(leaning_toward_light),
    observed(low_light).


% ---------------- Excessive Sunlight ----------------

likely_problem(excessive_sunlight) :-
    observed(bleached_leaves),
    observed(strong_direct_sun).

likely_problem(excessive_sunlight) :-
    observed(brown_dry_patches),
    observed(strong_direct_sun).

likely_problem(excessive_sunlight) :-
    observed(leaf_scorch),
    observed(hot_dry_conditions).


% ---------------- Nitrogen Deficiency ----------------

likely_problem(nitrogen_deficiency) :-
    observed(older_leaves_yellow),
    observed(slow_growth).

likely_problem(nitrogen_deficiency) :-
    observed(lower_leaves_yellow),
    observed(pale_growth).

likely_problem(nitrogen_deficiency) :-
    observed(older_leaves_yellow),
    observed(stunted_growth).


% ---------------- Potassium Deficiency ----------------

likely_problem(potassium_deficiency) :-
    observed(yellow_leaf_edges),
    observed(older_leaves_affected).

likely_problem(potassium_deficiency) :-
    observed(brown_leaf_edges),
    observed(older_leaves_affected).

likely_problem(potassium_deficiency) :-
    observed(yellow_leaf_edges),
    observed(stunted_growth).


% ---------------- Aphids ----------------

likely_problem(aphids) :-
    observed(curled_leaves),
    observed(sticky_leaves).

likely_problem(aphids) :-
    observed(sticky_leaves),
    observed(small_insects).

likely_problem(aphids) :-
    observed(curled_leaves),
    observed(small_insects).

likely_problem(aphids) :-
    observed(yellow_leaves),
    observed(sticky_leaves),
    observed(slow_growth).


% ---------------- Spider Mites ----------------

likely_problem(spider_mites) :-
    observed(webbing),
    observed(tiny_leaf_spots).

likely_problem(spider_mites) :-
    observed(webbing),
    observed(yellow_speckling).

likely_problem(spider_mites) :-
    observed(tiny_leaf_spots),
    observed(hot_dry_conditions).

likely_problem(spider_mites) :-
    observed(webbing),
    observed(leaf_drop).


% ---------------- Powdery Mildew ----------------

likely_problem(powdery_mildew) :-
    observed(white_powder),
    observed(leaf_surface_affected).

likely_problem(powdery_mildew) :-
    observed(white_powder),
    observed(curled_leaves).

likely_problem(powdery_mildew) :-
    observed(white_powder),
    observed(yellow_leaves).


% ============================================================
% SECTION 3 - EXPLANATION RULES
% ============================================================

explanation(overwatering,
    'Wet soil together with yellow leaves, wilting, or slow growth suggests possible overwatering.').

explanation(underwatering,
    'Dry soil together with wilting or dry leaf edges suggests possible underwatering.').

explanation(poor_drainage,
    'Wet soil together with poor drainage or stress symptoms suggests that water may remain around the roots.').

explanation(insufficient_light,
    'Low light together with weak, pale, or slow growth suggests insufficient light.').

explanation(excessive_sunlight,
    'Strong sunlight or hot conditions together with scorched or bleached leaves suggests excessive sunlight stress.').

explanation(nitrogen_deficiency,
    'Yellowing of older or lower leaves together with poor growth can indicate a nitrogen-related problem.').

explanation(potassium_deficiency,
    'Yellow or brown leaf edges, especially on older leaves, can indicate a potassium-related problem.').

explanation(aphids,
    'Curled or sticky leaves together with small insects are signs consistent with aphid activity.').

explanation(spider_mites,
    'Fine webbing together with tiny spots or yellow speckling is consistent with spider mite activity.').

explanation(powdery_mildew,
    'White powdery material on the leaf surface is consistent with powdery mildew.').


% ============================================================
% SECTION 4 - FORWARD CHAINING
% ============================================================

forward_rule :-
    observed(curled_leaves),
    observed(sticky_leaves),
    \+ inferred(aphid_signs),
    assertz(inferred(aphid_signs)).

forward_rule :-
    inferred(aphid_signs),
    observed(small_insects),
    \+ inferred(aphids),
    assertz(inferred(aphids)).


forward_rule :-
    observed(webbing),
    observed(yellow_speckling),
    \+ inferred(mite_signs),
    assertz(inferred(mite_signs)).

forward_rule :-
    inferred(mite_signs),
    \+ inferred(spider_mites),
    assertz(inferred(spider_mites)).


forward_rule :-
    observed(wet_soil),
    observed(yellow_leaves),
    \+ inferred(excess_water_signs),
    assertz(inferred(excess_water_signs)).

forward_rule :-
    inferred(excess_water_signs),
    observed(slow_growth),
    \+ inferred(overwatering),
    assertz(inferred(overwatering)).


forward_rule :-
    observed(dry_soil),
    observed(wilting),
    \+ inferred(dryness_signs),
    assertz(inferred(dryness_signs)).

forward_rule :-
    inferred(dryness_signs),
    \+ inferred(underwatering),
    assertz(inferred(underwatering)).


forward_rule :-
    observed(white_powder),
    observed(leaf_surface_affected),
    \+ inferred(fungal_signs),
    assertz(inferred(fungal_signs)).

forward_rule :-
    inferred(fungal_signs),
    \+ inferred(powdery_mildew),
    assertz(inferred(powdery_mildew)).


% Run forward rules repeatedly until no new facts can be created.

forward_chain :-
    forward_rule,
    !,
    forward_chain.

forward_chain.


% ============================================================
% SECTION 5 - DISPLAY DIAGNOSIS
% ============================================================

show_problem(Problem) :-
    category(Problem, Category),
    description(Problem, Description),
    explanation(Problem, Explanation),
    recommendation(Problem, Recommendation),

    format('~n========================================~n'),
    format('LIKELY PROBLEM: ~w~n', [Problem]),
    format('CATEGORY: ~w~n', [Category]),
    format('----------------------------------------~n'),
    format('DESCRIPTION:~n~w~n', [Description]),
    format('~nREASONING:~n~w~n', [Explanation]),
    format('~nRECOMMENDATION:~n~w~n', [Recommendation]),
    format('========================================~n').


% Find all problems using backward chaining.

diagnose :-
    findall(Problem, likely_problem(Problem), Problems),
    sort(Problems, UniqueProblems),
    (
        UniqueProblems = []
        ->
        write('No clear problem could be identified from the current symptoms.'), nl
        ;
        show_results(UniqueProblems)
    ).


% Display every identified problem.

show_results([]).

show_results([Problem|Rest]) :-
    show_problem(Problem),
    show_results(Rest).

% ============================================================
% SECTION 6 - SHOW FORWARD CHAINING RESULTS
% ============================================================

show_forward_results :-
    forward_chain,
    findall(X, inferred(X), Results),
    sort(Results, UniqueResults),
    format('~nForward Chaining Inferences: ~w~n', [UniqueResults]).


% ============================================================
% SECTION 7 - CLEAR PREVIOUS CASE
% ============================================================

clear_case :-
    retractall(observed(_)),
    retractall(inferred(_)),
    write('Previous case cleared.'), nl.


% ============================================================
% SECTION 8 - ADD SYMPTOM
% ============================================================

add_symptom(Symptom) :-
    ( observed(Symptom) ->
        true
    ;
        assertz(observed(Symptom))
    ).


% ============================================================
% SECTION 9 - SHOW CURRENT SYMPTOMS
% ============================================================

show_symptoms :-
    findall(Symptom, observed(Symptom), Symptoms),
    format('Current symptoms: ~w~n', [Symptoms]).
