package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet("/calculate")
public class ElectricityBillServlet extends HttpServlet {

    private static final BigDecimal FIRST_SLAB_LIMIT = new BigDecimal("50");
    private static final BigDecimal SECOND_SLAB_LIMIT = new BigDecimal("100");
    private static final BigDecimal THIRD_SLAB_LIMIT = new BigDecimal("100");
    private static final BigDecimal FIRST_SLAB_RATE = new BigDecimal("3.50");
    private static final BigDecimal SECOND_SLAB_RATE = new BigDecimal("4.00");
    private static final BigDecimal THIRD_SLAB_RATE = new BigDecimal("5.20");
    private static final BigDecimal FOURTH_SLAB_RATE = new BigDecimal("6.50");
    private static final Pattern ALPHANUMERIC_ID_PATTERN = Pattern.compile("^[A-Za-z0-9]+$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String customerName = request.getParameter("customerName");
        String customerId = request.getParameter("customerId");
        String unitsRaw = request.getParameter("units");
        String error = "";
        BigDecimal units = null;

        customerName = customerName == null ? "" : customerName.trim();
        customerId = customerId == null ? "" : customerId.trim();
        unitsRaw = unitsRaw == null ? "" : unitsRaw.trim();

        if (customerName.isEmpty()) {
            error = "Please enter your name.";
        } else if (customerName.length() > 80) {
            error = "Name must be 80 characters or fewer.";
        } else if (!ALPHANUMERIC_ID_PATTERN.matcher(customerId).matches()) {
            error = "Customer ID must contain letters and numbers only.";
        } else if (customerId.length() > 40) {
            error = "Customer ID must be 40 characters or fewer.";
        }

        if (error.isEmpty()) {
            try {
                units = new BigDecimal(unitsRaw);
                if (units.signum() < 0) {
                    error = "Units cannot be negative.";
                } else if (units.stripTrailingZeros().scale() > 2) {
                    error = "Please enter units to no more than two decimal places.";
                }
            } catch (NumberFormatException ex) {
                error = "Please enter a valid number of units.";
            }
        }

        String bill = null;
        String breakdown = "";
        if (error.isEmpty()) {
            BigDecimal firstSlab = slabUsage(units, BigDecimal.ZERO, FIRST_SLAB_LIMIT)
                    .multiply(FIRST_SLAB_RATE);
            BigDecimal secondSlab = slabUsage(units, FIRST_SLAB_LIMIT, SECOND_SLAB_LIMIT)
                    .multiply(SECOND_SLAB_RATE);
            BigDecimal thirdSlab = slabUsage(units, FIRST_SLAB_LIMIT.add(SECOND_SLAB_LIMIT), THIRD_SLAB_LIMIT)
                    .multiply(THIRD_SLAB_RATE);
            BigDecimal fourthSlab = units.subtract(FIRST_SLAB_LIMIT)
                    .subtract(SECOND_SLAB_LIMIT)
                    .subtract(THIRD_SLAB_LIMIT)
                    .max(BigDecimal.ZERO)
                    .multiply(FOURTH_SLAB_RATE);

            bill = formatMoney(firstSlab.add(secondSlab).add(thirdSlab).add(fourthSlab));
            breakdown = "<li><span>First 50 units <small>· ₹3.50/unit</small></span><span>"
                    + formatMoney(firstSlab) + "</span></li>"
                    + "<li><span>Next 100 units <small>· ₹4.00/unit</small></span><span>"
                    + formatMoney(secondSlab) + "</span></li>"
                    + "<li><span>Next 100 units <small>· ₹5.20/unit</small></span><span>"
                    + formatMoney(thirdSlab) + "</span></li>"
                    + "<li><span>Above 250 units <small>· ₹6.50/unit</small></span><span>"
                    + formatMoney(fourthSlab) + "</span></li>";
        }

        request.setAttribute("customerName", escapeHtml(customerName));
        request.setAttribute("customerId", escapeHtml(customerId));
        request.setAttribute("units", escapeHtml(unitsRaw));
        request.setAttribute("error", escapeHtml(error));
        request.setAttribute("bill", bill);
        request.setAttribute("breakdown", breakdown);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private BigDecimal slabUsage(BigDecimal units, BigDecimal lowerBound, BigDecimal slabSize) {
        return units.subtract(lowerBound).max(BigDecimal.ZERO).min(slabSize);
    }

    private String formatMoney(BigDecimal amount) {
        DecimalFormat formatter = new DecimalFormat("₹#,##0.00",
                DecimalFormatSymbols.getInstance(Locale.US));
        return formatter.format(amount);
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
