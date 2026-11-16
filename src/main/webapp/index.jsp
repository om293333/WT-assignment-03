<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#f5f7f2">
    <title>WattWise — Electricity bill calculator</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            color-scheme: light;
            --ink: #18241d;
            --muted: #778078;
            --green: #1b704b;
            --green-dark: #15583b;
            --mint: #eaf3e9;
            --line: #e8ece5;
            --paper: #fff;
        }

        * { box-sizing: border-box; }

        body {
            min-height: 100vh;
            margin: 0;
            color: var(--ink);
            background:
                radial-gradient(ellipse at 80% 12%, rgba(218, 234, 212, .58), transparent 34rem),
                #f5f7f2;
            font-family: "DM Sans", sans-serif;
        }

        h1, h2, h3, .brand, .amount { font-family: "Manrope", sans-serif; }
        .page-shell { max-width: 1120px; }
        .topbar { padding: 26px 0 20px; }
        .brand {
            display: inline-flex;
            align-items: center;
            gap: 11px;
            color: var(--ink);
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -.7px;
            text-decoration: none;
        }
        .brand-mark {
            display: grid;
            width: 38px;
            height: 38px;
            place-items: center;
            border-radius: 12px;
            color: #fff;
            background: var(--green);
        }
        .top-note { color: var(--muted); font-size: 13px; }
        .hero { padding: 42px 0 32px; }
        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 18px;
            color: var(--green);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }
        .eyebrow::before {
            width: 20px;
            height: 2px;
            content: "";
            background: #74a77e;
        }
        .hero h1 {
            max-width: 680px;
            margin: 0;
            font-size: clamp(2.3rem, 5vw, 4rem);
            font-weight: 700;
            letter-spacing: -2.8px;
            line-height: 1.1;
        }
        .hero h1 span { color: var(--green); }
        .hero p {
            max-width: 530px;
            margin: 18px 0 0;
            color: var(--muted);
            font-size: 16px;
            line-height: 1.7;
        }
        .calculator-card {
            overflow: hidden;
            border: 1px solid rgba(226, 232, 223, .9);
            border-radius: 20px;
            background: var(--paper);
            box-shadow: 0 18px 55px rgba(32, 49, 37, .07);
        }
        .form-panel { padding: 34px; }
        .section-heading {
            margin-bottom: 5px;
            font-family: "Manrope", sans-serif;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -.45px;
        }
        .section-copy { margin-bottom: 26px; color: var(--muted); font-size: 13px; }
        .form-label {
            margin-bottom: 8px;
            color: #354139;
            font-size: 12px;
            font-weight: 700;
        }
        .form-control {
            min-height: 51px;
            border-color: #e3e8e1;
            border-radius: 10px;
            color: var(--ink);
            font-size: 14px;
            box-shadow: none;
        }
        .form-control::placeholder { color: #a6aea7; }
        .form-control:focus {
            border-color: #78a98a;
            box-shadow: 0 0 0 3px rgba(27, 112, 75, .1);
        }
        .field-hint { margin-top: 7px; color: #929b93; font-size: 11px; }
        .calculate-btn {
            min-height: 52px;
            border: 0;
            border-radius: 10px;
            color: #fff;
            background: var(--green);
            font-size: 14px;
            font-weight: 700;
            transition: background .18s ease, transform .18s ease;
        }
        .calculate-btn:hover, .calculate-btn:focus-visible {
            color: #fff;
            background: var(--green-dark);
            transform: translateY(-1px);
        }
        .calculate-btn svg { margin-left: 7px; }
        .error-message {
            border: 1px solid #f1d0ca;
            border-radius: 10px;
            color: #9f3629;
            background: #fff5f2;
            font-size: 13px;
        }
        .result-panel {
            display: flex;
            min-height: 100%;
            flex-direction: column;
            padding: 34px;
            color: #fff;
            background:
                radial-gradient(ellipse at 95% 3%, rgba(146, 191, 147, .24), transparent 16rem),
                #1c3427;
        }
        .result-panel h2 {
            margin: 0;
            font-family: "Manrope", sans-serif;
            font-size: 18px;
            font-weight: 700;
        }
        .result-intro { margin: 7px 0 26px; color: #afc1b3; font-size: 12px; }
        .result-placeholder {
            display: flex;
            flex: 1;
            min-height: 240px;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 24px;
            border: 1px dashed rgba(210, 229, 212, .22);
            border-radius: 14px;
            color: #a4b9a8;
            text-align: center;
        }
        .placeholder-icon {
            display: grid;
            width: 54px;
            height: 54px;
            margin-bottom: 16px;
            place-items: center;
            border-radius: 17px;
            color: #c3dec4;
            background: rgba(255, 255, 255, .08);
        }
        .result-placeholder strong { margin-bottom: 6px; color: #e2ece3; font-size: 14px; }
        .result-placeholder span { max-width: 210px; font-size: 12px; line-height: 1.6; }
        .bill-result { animation: appear .35s ease both; }
        @keyframes appear {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .customer-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            max-width: 100%;
            padding: 8px 11px;
            border: 1px solid rgba(255, 255, 255, .12);
            border-radius: 9px;
            color: #d9e7da;
            background: rgba(255, 255, 255, .06);
            font-size: 12px;
        }
        .customer-chip span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .amount-label {
            margin: 28px 0 5px;
            color: #b2c3b5;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .amount { font-size: clamp(2.5rem, 5vw, 3.5rem); font-weight: 700; letter-spacing: -2px; }
        .amount-caption { margin: 2px 0 25px; color: #9eb29f; font-size: 12px; }
        .breakdown-title {
            display: flex;
            justify-content: space-between;
            margin-bottom: 13px;
            color: #dbe7dc;
            font-size: 12px;
            font-weight: 700;
        }
        .breakdown-list { margin: 0; padding: 0; list-style: none; }
        .breakdown-list li {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 10px 0;
            border-top: 1px solid rgba(255, 255, 255, .11);
            color: #b8c8ba;
            font-size: 11px;
        }
        .breakdown-list li span:last-child { color: #edf5ed; font-weight: 600; white-space: nowrap; }
        .breakdown-list small { color: #869d89; font-size: 10px; }
        .result-footnote {
            margin: auto 0 0;
            padding-top: 20px;
            color: #8fa491;
            font-size: 10px;
            line-height: 1.6;
        }
        .tariff-section { padding: 36px 0 48px; }
        .tariff-heading { margin-bottom: 17px; }
        .tariff-heading h2 {
            margin: 0;
            font-family: "Manrope", sans-serif;
            font-size: 15px;
            font-weight: 800;
        }
        .tariff-heading span { color: var(--muted); font-size: 11px; }
        .tariff-card {
            height: 100%;
            padding: 18px;
            border: 1px solid var(--line);
            border-radius: 13px;
            background: rgba(255, 255, 255, .72);
        }
        .tariff-units { margin-bottom: 9px; color: #838c84; font-size: 11px; }
        .tariff-rate { font-family: "Manrope", sans-serif; font-size: 20px; font-weight: 800; letter-spacing: -.5px; }
        .tariff-rate small { color: #7d887e; font-family: "DM Sans", sans-serif; font-size: 10px; font-weight: 500; }
        footer {
            padding: 18px 0 28px;
            border-top: 1px solid #e7ebe4;
            color: #89938b;
            font-size: 11px;
        }
        footer strong { color: #57645a; font-weight: 600; }

        @media (max-width: 767.98px) {
            .topbar { padding-top: 19px; }
            .hero { padding: 35px 0 27px; }
            .hero h1 { letter-spacing: -1.8px; }
            .hero p { font-size: 14px; }
            .form-panel, .result-panel { padding: 25px 22px; }
            .result-placeholder { min-height: 185px; }
            .tariff-section { padding-top: 27px; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { scroll-behavior: auto !important; animation-duration: .01ms !important; transition-duration: .01ms !important; }
        }
    </style>
</head>
<body>
<div class="container page-shell">
    <header class="topbar d-flex align-items-center justify-content-between">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="WattWise home">
            <span class="brand-mark" aria-hidden="true">
                <svg width="21" height="21" viewBox="0 0 24 24" fill="none">
                    <path d="M13.2 2.8 5.6 13h5.1l-.5 8.2L18.4 11h-5.2V2.8Z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/>
                </svg>
            </span>
            WattWise
        </a>
        <span class="top-note d-none d-sm-inline">Simple, transparent bill estimates</span>
    </header>

    <main>
        <section class="hero">
            <div class="eyebrow">Know before it’s due</div>
            <h1>Your electricity bill,<br><span>made clearer.</span></h1>
            <p>Estimate your energy charges in seconds. Enter your account details and monthly usage to see exactly how each tariff slab adds up.</p>
        </section>

        <section class="calculator-card" aria-label="Electricity bill calculator">
            <div class="row g-0">
                <div class="col-md-6">
                    <div class="form-panel">
                        <h2 class="section-heading">Your usage details</h2>
                        <p class="section-copy">A few details are all we need to get started.</p>
                        <form action="${pageContext.request.contextPath}/calculate" method="post" id="billForm">
                            <div class="mb-3">
                                <label for="customerName" class="form-label">Customer name</label>
                                <input type="text" name="customerName" id="customerName" class="form-control"
                                       placeholder="e.g. Asha Patel" autocomplete="name" maxlength="80" required
                                       value="${customerName}">
                            </div>
                            <div class="mb-3">
                                <label for="customerId" class="form-label">Customer ID</label>
                                <input type="text" name="customerId" id="customerId" class="form-control"
                                       placeholder="e.g. CUST001" autocomplete="off" maxlength="40"
                                       pattern="[A-Za-z0-9]+" title="Use letters and numbers only" required
                                       value="${customerId}">
                            </div>
                            <div class="mb-4">
                                <label for="units" class="form-label">Units consumed</label>
                                <input type="number" name="units" id="units" class="form-control"
                                       placeholder="e.g. 180" min="0" step="0.01" inputmode="decimal" required
                                       value="${units}">
                                <div class="field-hint">Check your meter or monthly statement for your usage.</div>
                            </div>
                            <button type="submit" class="btn calculate-btn w-100">
                                Calculate my bill
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                    <path d="M5 12h14m-6-6 6 6-6 6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </form>

                        <div class="alert error-message mt-3 mb-0 ${empty error ? 'd-none' : ''}" role="alert">
                            ${error}
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="result-panel">
                        <h2>Your estimate</h2>
                        <p class="result-intro">A clear breakdown, with no surprises.</p>
                        <div class="bill-result ${empty bill ? 'd-none' : ''}" aria-live="polite">
                            <div class="customer-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                    <circle cx="12" cy="8" r="3.2" stroke="currentColor" stroke-width="1.6"/>
                                    <path d="M5.5 20c.7-3.6 2.9-5.4 6.5-5.4s5.8 1.8 6.5 5.4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                                </svg>
                                <span>${customerName} · ${customerId}</span>
                            </div>
                            <div class="amount-label">Estimated energy charges</div>
                            <div class="amount">${bill}</div>
                            <div class="amount-caption">for ${units} units consumed</div>
                            <div class="breakdown-title">
                                <span>Slab-wise breakdown</span>
                                <span>Amount</span>
                            </div>
                            <ul class="breakdown-list">
                                ${breakdown}
                            </ul>
                            <p class="result-footnote">Estimate based on the listed per-unit rates. Taxes, fixed charges and other fees are not included.</p>
                        </div>
                        <div class="result-placeholder ${empty bill ? '' : 'd-none'}">
                            <div class="placeholder-icon" aria-hidden="true">
                                <svg width="25" height="25" viewBox="0 0 24 24" fill="none">
                                    <path d="M4 19V9m5 10V5m5 14v-7m5 7V3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                                </svg>
                            </div>
                            <strong>Your estimate will appear here</strong>
                            <span>Enter your details and usage to see your personalized bill breakdown.</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="tariff-section" aria-labelledby="tariffHeading">
            <div class="tariff-heading d-flex align-items-center justify-content-between">
                <h2 id="tariffHeading">How your usage is priced</h2>
                <span>Progressive slab rates</span>
            </div>
            <div class="row g-3">
                <div class="col-6 col-lg-3">
                    <div class="tariff-card">
                        <div class="tariff-units">First 50 units</div>
                        <div class="tariff-rate">₹3.50 <small>/ unit</small></div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="tariff-card">
                        <div class="tariff-units">Next 100 units <span>(51–150)</span></div>
                        <div class="tariff-rate">₹4.00 <small>/ unit</small></div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="tariff-card">
                        <div class="tariff-units">Next 100 units <span>(151–250)</span></div>
                        <div class="tariff-rate">₹5.20 <small>/ unit</small></div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="tariff-card">
                        <div class="tariff-units">Above 250 units</div>
                        <div class="tariff-rate">₹6.50 <small>/ unit</small></div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="d-flex flex-column flex-sm-row justify-content-between gap-1">
        <span><strong>WattWise</strong> · Electricity bill calculator</span>
        <span>Estimate only — your provider’s final bill may vary.</span>
    </footer>
</div>
</body>
</html>
