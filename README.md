# WattWise Electricity Bill Calculator

A responsive Java web application built with Jakarta `Servlet` + `JSP` and Bootstrap. Enter a customer name, customer ID and consumed units to see the estimated bill and a per-slab cost breakdown.

## Tariff Rules
- First 50 units: ₹3.50 per unit
- Next 100 units: ₹4.00 per unit
- Next 100 units: ₹5.20 per unit
- Above 250 units: ₹6.50 per unit

## Project Structure
- `src/main/java/com/example/ElectricityBillServlet.java` – servlet for bill calculation
- `src/main/webapp/index.jsp` – responsive Bootstrap calculator interface
- `src/main/webapp/WEB-INF/web.xml` – deployment descriptor
- `pom.xml` – Maven build configuration

## Run
1. Install Java 17, Maven and Apache Tomcat 10.1 or later.
2. Open a terminal in the project folder.
3. Run:
   ```bash
   mvn clean package
   ```
4. Deploy `target/electricity-bill-calculator.war` to Tomcat.
5. Open:
   ```text
   http://localhost:8080/electricity-bill-calculator/
   ```

The estimate covers energy charges using the listed progressive slab rates. Taxes, fixed charges and other provider fees are not included.
