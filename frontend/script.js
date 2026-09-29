const diagnoseButton = document.getElementById("diagnoseButton");
const clearButton = document.getElementById("clearButton");
const resultSection = document.getElementById("resultSection");
const resultsContainer = document.getElementById("results");
const resultSummary = document.getElementById("resultSummary");
const selectedBar = document.getElementById("selectedBar");
const countLabel = document.getElementById("countLabel");
const searchBox = document.getElementById("searchBox");
const noMatch = document.getElementById("noMatch");
const toast = document.getElementById("toast");

const checkboxes = Array.from(
    document.querySelectorAll('.symptom-group input[type="checkbox"]')
);

let toastTimer;


// ----------------------------------------------------
// Events
// ----------------------------------------------------

diagnoseButton.addEventListener("click", diagnosePlant);
clearButton.addEventListener("click", clearForm);
searchBox.addEventListener("input", filterSymptoms);

checkboxes.forEach(box => box.addEventListener("change", updateSelection));

updateSelection();


// ----------------------------------------------------
// Helpers
// ----------------------------------------------------

function labelOf(checkbox) {
    return checkbox.nextElementSibling.textContent.trim();
}

function escapeHTML(text) {
    return String(text ?? "")
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;");
}

function showToast(message) {
    toast.textContent = message;
    toast.classList.remove("hidden");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.add("hidden"), 5000);
}


// ----------------------------------------------------
// Selection summary, counts and chips
// ----------------------------------------------------

function updateSelection() {

    const selected = checkboxes.filter(box => box.checked);

    countLabel.textContent =
        selected.length === 1 ? "1 symptom selected"
                              : `${selected.length} symptoms selected`;

    diagnoseButton.disabled = selected.length === 0;
    clearButton.disabled = selected.length === 0;

    // chips
    selectedBar.innerHTML = "";

    if (selected.length === 0) {
        selectedBar.innerHTML =
            '<span class="hint">No symptoms selected yet. Tick anything that matches your plant.</span>';
    }

    selected.forEach(box => {
        const tag = document.createElement("span");
        tag.className = "tag";
        tag.innerHTML =
            `${escapeHTML(labelOf(box))}
             <button type="button" aria-label="Remove ${escapeHTML(labelOf(box))}">✕</button>`;

        tag.querySelector("button").addEventListener("click", () => {
            box.checked = false;
            updateSelection();
        });

        selectedBar.appendChild(tag);
    });

    // per-group counts
    document.querySelectorAll(".symptom-group").forEach(group => {
        const n = group.querySelectorAll("input:checked").length;
        group.querySelector("[data-count]").textContent = n || "";
    });
}


// ----------------------------------------------------
// Search filter
// ----------------------------------------------------

function filterSymptoms() {

    const term = searchBox.value.trim().toLowerCase();
    let visibleTotal = 0;

    document.querySelectorAll(".symptom-group").forEach(group => {

        let visibleInGroup = 0;

        group.querySelectorAll("label").forEach(label => {
            const match = label.textContent.toLowerCase().includes(term);
            label.classList.toggle("hidden", !match);
            if (match) visibleInGroup++;
        });

        group.classList.toggle("hidden", visibleInGroup === 0);

        if (term && visibleInGroup > 0) group.open = true;

        visibleTotal += visibleInGroup;
    });

    noMatch.classList.toggle("hidden", visibleTotal > 0);
}


// ----------------------------------------------------
// Diagnose plant (same API contract as before)
// ----------------------------------------------------

async function diagnosePlant() {

    const symptoms = checkboxes
        .filter(box => box.checked)
        .map(box => box.value);

    if (symptoms.length === 0) {
        showToast("Please select at least one symptom.");
        return;
    }

    diagnoseButton.disabled = true;
    diagnoseButton.innerHTML = '<span class="spinner"></span>Diagnosing...';

    try {

        const response = await fetch("/api/diagnose", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ symptoms: symptoms })
        });

        if (!response.ok) {
            throw new Error("Server error.");
        }

        const data = await response.json();

        displayResults(data.results || []);

    }
    catch (error) {

        console.error(error);

        showToast(
            "Could not reach the expert system. Check that the server is running and try again."
        );

    }
    finally {

        diagnoseButton.textContent = "Diagnose plant";
        diagnoseButton.disabled = checkboxes.every(box => !box.checked);
    }
}


// ----------------------------------------------------
// Display diagnosis
// ----------------------------------------------------

function displayResults(results) {

    resultsContainer.innerHTML = "";
    resultSection.classList.remove("hidden");

    if (results.length === 0) {

        resultSummary.textContent = "";

        resultsContainer.innerHTML = `
            <div class="no-result">
                <strong>No clear problem identified.</strong>
                <p>
                    These symptoms don't give the rule base enough evidence
                    to reach a conclusion. Try adding more symptoms, such as
                    soil moisture, light conditions or signs of pests.
                </p>
            </div>
        `;

    } else {

        resultSummary.textContent =
            results.length === 1
                ? "We found 1 likely problem."
                : `We found ${results.length} possible problems.`;

        results.forEach(result => {

            const card = document.createElement("article");
            card.className = "problem-card";

            card.innerHTML = `
                <header>
                    <h3>${escapeHTML(formatName(result.problem))}</h3>
                    <span class="badge">${escapeHTML(formatName(result.category))}</span>
                </header>

                <dl>
                    <dt>What it is</dt>
                    <dd>${escapeHTML(result.description)}</dd>

                    <dt>Why we think so</dt>
                    <dd>${escapeHTML(result.explanation)}</dd>
                </dl>

                <div class="recommend">
                    <strong>What to do</strong>
                    ${escapeHTML(result.recommendation)}
                </div>
            `;

            resultsContainer.appendChild(card);
        });
    }

    resultSection.scrollIntoView({ behavior: "smooth", block: "start" });
}


// ----------------------------------------------------
// Convert Prolog names into readable text
// spider_mites -> Spider Mites
// ----------------------------------------------------

function formatName(name) {

    return String(name ?? "")
        .replaceAll("_", " ")
        .replace(/\b\w/g, letter => letter.toUpperCase());
}


// ----------------------------------------------------
// Clear UI
// ----------------------------------------------------

function clearForm() {

    checkboxes.forEach(box => box.checked = false);

    searchBox.value = "";
    filterSymptoms();
    updateSelection();

    resultsContainer.innerHTML = "";
    resultSection.classList.add("hidden");

    window.scrollTo({ top: 0, behavior: "smooth" });
}