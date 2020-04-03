import java.util.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AreaCheckServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		/*out.println("attrs:");
		List<String> it = Collections.list(request.getAttributeNames());
		for (String s : it)
			out.println(s);
		return;*/
		double x = Double.valueOf(request.getParameter("x"));
		double y = Double.valueOf(request.getParameter("y"));
		double r = Double.valueOf(request.getParameter("r"));
		boolean res = false;
		if (x >= 0 && y >= 0) {
	 		res = (x * x + y * y <= r * r);
	 	}
		if (!res && x <= 0 && y >= 0) {
			res = (y - x <= r);
		}
		if (!res && x <= 0 && y <= 0) {
			res = (x >= -r / 2) && (y >= -r);
		}
		out.println("<table>");
		out.println("<tr><td>X:</td><td>" + Double.toString(x) + "</td></tr>");
		out.println("<tr><td>Y:</td><td>" + Double.toString(y) + "</td></tr>");
		out.println("<tr><td>R:</td><td>" + Double.toString(r) + "</td></tr>");
		out.println("<tr><td>Result:</td><td>" + (res ? "hit" : "miss") + "</td></tr>");
		out.println("</table>");
		out.println("<a href = \"/lab1/\"> try again </a>");
		ServletContext sc = getServletContext();
		if (sc.getAttribute("history") == null || !(sc.getAttribute("history") instanceof String))
			sc.setAttribute("history", "");
		if (sc.getAttribute("historyArray") == null || !(sc.getAttribute("historyArray") instanceof String))
			sc.setAttribute("historyArray", "");
		String history = (String)sc.getAttribute("history");
		sc.setAttribute("history", history + "<tr><td>" + Double.toString(x) + "</td><td>" + Double.toString(y) + "</td><td>" 
			+ Double.toString(r) + "</td><td>" + (res ? "hit" : "miss") + "</td></tr>");
		if (Math.abs(x) < 1.1 * Math.abs(r) && Math.abs(y) < 1.1 * Math.abs(r))
			{
				String historyArray = (String)sc.getAttribute("historyArray");
				historyArray = historyArray + ((historyArray.length() > 0) ? "," : "") + " {x: " + Double.toString(x / r) +  ", y: " + Double.toString(y / r) + ", col: \"" + (res ? "#0f0" : "#f00") + "\"}";
				sc.setAttribute("historyArray", historyArray);
			}
	}
}
