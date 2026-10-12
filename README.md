# Evans Uwadone

Junior data analyst building a portfolio with **Excel, SQL and Power BI**.

I'm interested in preparing data, writing clear calculations, and explaining business findings through readable reports. This repository begins with a guided retail sales project using simulated data. The supplied analysis is a starting point for practice and personal extensions.

## Featured project

### Retail sales performance

Analyse sales, gross profit and returns for a fictional Nigerian retailer across 2025.

| Question | Finding in the simulated sample |
| --- | --- |
| How much net revenue was generated? | ₦37,176,500 across 1,500 clean transactions |
| Which category leads revenue? | Electronics, with ₦13,014,050 and 35.0% of total revenue |
| Which category has the highest gross margin? | Beauty, at 45.1% |
| Which category deserves a closer look at returns? | Fashion, at 14.8% versus 8.2% overall |

[Read the project case study](projects/retail-sales/README.md) · [Open the Excel workbook](projects/retail-sales/excel/Retail_Sales_Analysis.xlsx) · [Inspect the SQL](projects/retail-sales/sql/02_analysis.sql)

**Project status:** Excel workbook and SQL analysis supplied and verified. Power BI guide, import query, DAX measures and theme supplied. The Power BI report has not yet been built. This is a guided project created with assistance; reproduce it and add original work before presenting it as independently completed analysis.

## Get started

1. Open `START_HERE.md` and work through the project checklist.
2. Open `index.html` in a browser to explore the portfolio. The page works locally and needs no package installation.
3. Edit `assets/profile.js` to add your GitHub username and optional contact email. Empty links stay hidden.
4. Run the SQL and check the Excel workbook. Build the Power BI report from the included guide.
5. Add your own question, query, chart and interpretation. Update the status when you complete that work.

## Put the portfolio on GitHub

1. Create a repository named `data-analyst-portfolio`. Choose a public repository if you use GitHub Free and want a Pages website.
2. Extract the ZIP. Upload the **contents** of `evans-data-portfolio`, preserving the `assets` and `projects` folders. `index.html` must sit at the repository root. Do not upload the ZIP as the website.
3. Include `.nojekyll` to keep the site files unchanged. If your file browser hides it, use GitHub's **Add file → Create new file**, name the file `.nojekyll`, put `Disable Jekyll` on its first line, and commit it.
4. In the repository, open **Settings → Pages**. Set the publishing source to **Deploy from a branch**, select **main** and **/(root)**, then save.
5. Use the website URL shown in Pages settings. For a project repository, the usual address is `https://YOUR_USERNAME.github.io/data-analyst-portfolio/`.

These branch and folder settings follow the [official GitHub Pages guide](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

For a GitHub profile introduction, copy the text in `PROFILE_README.md` into the `README.md` of a separate public repository named exactly the same as your GitHub username. Personalise the wording and add project links after creating this portfolio repository. See [GitHub's profile README instructions](https://docs.github.com/en/account-and-profile/how-tos/profile-customization/managing-your-profile-readme).

## Repository contents

| Path | Purpose |
| --- | --- |
| `index.html`, `project.html`, `assets/` | Portfolio website and interactive data explorer |
| `PROFILE_README.md` | Draft introduction for a GitHub profile |
| `START_HERE.md` | Learning and publishing checklist |
| `projects/retail-sales/data/` | Original, clean and rejected CSVs, plus a SQLite database |
| `projects/retail-sales/sql/` | Setup, cleaning and analysis scripts |
| `projects/retail-sales/analysis/` | Query outputs, definitions, findings and validation record |
| `projects/retail-sales/excel/` | Formula-based Excel analysis with filters and an editable chart |
| `projects/retail-sales/power-bi/` | Report build guide, Power Query, DAX measures and theme |

## Data provenance and limits

All transactions, prices, dates and outcomes are generated for this exercise. They do not represent real customers, sales, Nigerian market conditions, or business achievements. The dataset includes intentional quality issues. Returned transactions are fully refunded, with saleable stock recovered at full cost. Tax, shipping, overhead and return handling costs are excluded.

The website is ordinary HTML, CSS and JavaScript with relative paths. No build process, account integration or third-party fonts are required. Calculations and links were checked programmatically; a browser layout check and a native Excel/Power BI session were not available in the creation environment. Review the site on your phone and desktop before publishing.

## Next projects

After finishing this project, extend the portfolio with customer retention analysis and an operations performance report. Treat these as planned work until you have the data, analysis and report files.
