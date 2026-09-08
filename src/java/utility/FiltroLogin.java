package utility;

import beans.Soggetto;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class FiltroLogin implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req=(HttpServletRequest)request;
        HttpServletResponse res=(HttpServletResponse)response;

        String pagina=req.getRequestURI();

        // Pagine pubbliche
        if(pagina.endsWith("/index.jsp") || 
            pagina.endsWith("/login.jsp") ||
            pagina.endsWith("/__login.jsp") ||
            pagina.endsWith("/errore.jsp") ||
            pagina.contains("/css/") ||
            pagina.contains("/js/") ||
            pagina.contains("/img/")){
            chain.doFilter(request,response);
            return;
        }

        HttpSession session=req.getSession(false);
        Soggetto utente=session==null ? null : (Soggetto)session.getAttribute("utente");

        if(utente==null){
            res.sendRedirect(Utility.url+"/index.jsp");
            return;
        }

        chain.doFilter(request,response);
    }

    @Override
    public void destroy() {
    }
}