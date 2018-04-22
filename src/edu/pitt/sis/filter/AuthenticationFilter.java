//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package edu.pitt.sis.filter;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;

import edu.pitt.sis.beans.*;

public class AuthenticationFilter implements Filter {

	private String onFailure = "login.do";
	private FilterConfig filterConfig;

	
	public void init(FilterConfig filterConfig)throws ServletException{
		this.filterConfig = filterConfig;
		onFailure = filterConfig.getInitParameter("onFailure");		
	}

	
	public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain) throws IOException,ServletException{
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse)response;
		//System.out.println(req.getServletPath());
		if (req.getServletPath().equals(onFailure)){
			chain.doFilter(request,response);
			return;
		}
		
		HttpSession session = req.getSession();
		UserBean user = (UserBean)session.getAttribute("UserSession");
		if (user == null){			
			res.sendRedirect(req.getContextPath()+onFailure);
		}
		else{
			chain.doFilter(request,response);
		}		
	}
	
	public void destroy(){}
}