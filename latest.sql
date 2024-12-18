--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: generate_category_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_category_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
BEGIN    
    seq_value := nextval('category_sequence');    
    RETURN 'CTY_' || seq_value;
END;
$$;


ALTER FUNCTION public.generate_category_sequence() OWNER TO postgres;

--
-- Name: generate_dar_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_dar_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
BEGIN    
    seq_value := nextval('dar_sequence');    
    RETURN 'DAR_' || seq_value;
END;
$$;


ALTER FUNCTION public.generate_dar_sequence() OWNER TO postgres;

--
-- Name: generate_estimation_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_estimation_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
BEGIN    
    seq_value := nextval('estimation_sequence');    
    RETURN 'EST_' || seq_value;
END;
$$;


ALTER FUNCTION public.generate_estimation_sequence() OWNER TO postgres;

--
-- Name: generate_order_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_order_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
BEGIN    
    seq_value := nextval('order_sequence');    
    RETURN 'ORD_' || seq_value;
END;
$$;


ALTER FUNCTION public.generate_order_sequence() OWNER TO postgres;

--
-- Name: generate_product_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_product_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
BEGIN    
    seq_value := nextval('product_sequence');    
    RETURN 'PDT_' || seq_value;
END;
$$;


ALTER FUNCTION public.generate_product_sequence() OWNER TO postgres;

--
-- Name: generate_user_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_user_id() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
    generated_id TEXT;
BEGIN    
    seq_value := nextval('user_id_sequence');
    generated_id := 'USR_' || seq_value;
    RETURN generated_id;
END;
$$;


ALTER FUNCTION public.generate_user_id() OWNER TO postgres;

--
-- Name: generate_user_id_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_user_id_sequence() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seq_value INT;
    generated_id TEXT;
BEGIN    
    seq_value := nextval('user_id_sequence');
    generated_id := 'USR_' || seq_value;
    RETURN generated_id;
END;
$$;


ALTER FUNCTION public.generate_user_id_sequence() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id uuid NOT NULL,
    category_id character varying(255),
    category character varying(255),
    created_date timestamp without time zone,
    created_by character varying(255)
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- Name: getfiltercategorydetailslist(character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfiltercategorydetailslist(categoryid character varying, categoryname character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.product_category
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        product_category m1
    WHERE     
        (categoryId IS NULL OR lower(m1.category_id) ILIKE lower(categoryId) || '%')            
        AND (categoryName IS NULL OR lower(m1.category) ILIKE lower(categoryName) || '%')        
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfiltercategorydetailslist(categoryid character varying, categoryname character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: dar_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dar_details (
    id uuid NOT NULL,
    dar_no character varying(255),
    dar_process_date timestamp without time zone,
    planned_activity text,
    delivery_place_name_and_address text,
    state_cum_area character varying(255),
    client_name character varying(255),
    client_mobile_no character varying(255),
    about_the_client text,
    product_details text,
    from_location text,
    to_location text,
    total_expenses character varying(255),
    status_to_visit character varying(255),
    created_date timestamp without time zone,
    created_by character varying(255)
);


ALTER TABLE public.dar_details OWNER TO postgres;

--
-- Name: getfilterdardetailslist(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterdardetailslist(darno character varying, darperformfromdate timestamp without time zone, darperformtodate timestamp without time zone, clientname character varying, clientmobileno character varying, statustovisit character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.dar_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        dar_details m1
    WHERE
        (darNo IS NULL OR lower(m1.dar_no) ILIKE lower(darNo) || '%')                         
        AND (darPerformFromDate IS NULL OR darPerformToDate IS NULL OR m1.dar_process_date BETWEEN darPerformFromDate AND darPerformToDate)
        AND (clientName IS NULL OR lower(m1.client_name) ILIKE lower(clientName) || '%') 
        AND (clientMobileNo IS NULL OR lower(m1.client_mobile_no) ILIKE lower(clientMobileNo) || '%')
        AND (statusToVisit IS NULL OR lower(m1.status_to_visit) ILIKE lower(statusToVisit) || '%')                   
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterdardetailslist(darno character varying, darperformfromdate timestamp without time zone, darperformtodate timestamp without time zone, clientname character varying, clientmobileno character varying, statustovisit character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: estimation_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estimation_details (
    id uuid NOT NULL,
    est_no character varying(255),
    customer_name character varying(255),
    estimation_process_date timestamp without time zone,
    rep_attd character varying(255),
    rep_account character varying(255),
    billing_address text,
    delivery_address text,
    customer_city character varying(255),
    customer_pin_code character varying(255),
    customer_phone character varying(255),
    customer_email character varying(255),
    delivery_city character varying(255),
    delivery_pin_code character varying(255),
    warranty character varying(255),
    pan_and_gst character varying(255),
    ref character varying(255),
    remarks text,
    its_have_discount character varying(255),
    discount_estimate character varying(255),
    demo_piece_estimate character varying(255),
    stock_clearance_estimate character varying(255),
    discount_amount character varying(255),
    gst character varying(255),
    delivery_charges character varying(255),
    total_amount character varying(255),
    register_status character varying(255),
    created_by character varying(255),
    created_date timestamp(6) without time zone,
    total_product character varying(255)
);


ALTER TABLE public.estimation_details OWNER TO postgres;

--
-- Name: getfilterestimationdetailslist(character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterestimationdetailslist(estno character varying, customername character varying, estimationperformfromdate timestamp without time zone, estimationperformtodate timestamp without time zone, repattd character varying, repaccount character varying, mobileno character varying, itshavediscount character varying, estimationstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.estimation_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        estimation_details m1
    WHERE
    (estNo IS NULL OR lower(m1.est_no) ILIKE lower(estNo) || '%')  
    AND (customerName IS NULL OR lower(m1.customer_name) ILIKE lower(customerName) || '%') 
    AND (estimationPerformFromDate IS NULL OR estimationPerformToDate IS NULL OR m1.estimation_process_date BETWEEN estimationPerformFromDate AND estimationPerformToDate)        
    AND (repAttD IS NULL OR lower(m1.rep_attd) ILIKE lower(repAttD) || '%') 
    AND (repAccount IS NULL OR lower(m1.rep_account) ILIKE lower(repAccount) || '%')     
        AND (mobileNo IS NULL OR lower(m1.customer_phone) ILIKE lower(mobileNo) || '%')
        AND (itsHaveDiscount IS NULL OR lower(m1.its_have_discount) ILIKE lower(itsHaveDiscount) || '%')                   
        AND (estimationStatus IS NULL OR lower(m1.register_status) ILIKE lower(estimationStatus) || '%')                   
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterestimationdetailslist(estno character varying, customername character varying, estimationperformfromdate timestamp without time zone, estimationperformtodate timestamp without time zone, repattd character varying, repaccount character varying, mobileno character varying, itshavediscount character varying, estimationstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: order_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_details (
    id uuid NOT NULL,
    e_no character varying(255),
    est_no character varying(255),
    order_no character varying(255),
    so_no character varying(255),
    d_d_no character varying(255),
    customer_name character varying(255),
    billing_name character varying(255),
    billing_address text,
    customer_city character varying(255),
    customer_pin_code character varying(255),
    customer_phone character varying(255),
    customer_email character varying(255),
    rep_code character varying(255),
    demo_plan character varying(255),
    order_process_date timestamp without time zone,
    payment_charges character varying(255),
    payment_term_date timestamp without time zone,
    warranty character varying(255),
    pan_and_gst character varying(255),
    demo_date timestamp without time zone,
    delivery_address text,
    expected_date timestamp without time zone,
    ship_mode_name character varying(255),
    remarks text,
    total_product_amount character varying(255),
    gst character varying(255),
    delivery_charges character varying(255),
    total_amount character varying(255),
    less_advance character varying(255),
    balance character varying(255),
    register_status character varying(255),
    delivery_city character varying(255),
    delivery_pin_code character varying(255),
    demo_piece_estimate character varying(255),
    discount_amount character varying(255),
    discount_estimate character varying(255),
    its_have_discount character varying(255),
    stock_clearance_estimate character varying(255),
    payment_mode character varying(255),
    created_by character varying(255),
    created_date timestamp(6) without time zone
);


ALTER TABLE public.order_details OWNER TO postgres;

--
-- Name: getfilterorderdetailslist(character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterorderdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.order_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        order_details m1
    WHERE
        (eNo IS NULL OR lower(m1.e_no) ILIKE lower(eNo) || '%') 
        AND (estNo IS NULL OR lower(m1.est_no) ILIKE lower(estNo) || '%') 
        AND (orderNo IS NULL OR lower(m1.order_no) ILIKE lower(orderNo) || '%')  
        AND (soNo IS NULL OR lower(m1.so_no) ILIKE lower(soNo) || '%')  
        AND (ddNo IS NULL OR lower(m1.d_d_no) ILIKE lower(ddNo) || '%')  
        AND (customerName IS NULL OR lower(m1.customer_name) ILIKE lower(customerName) || '%')        
        AND (orderPerformFromDate IS NULL OR orderPerformToDate IS NULL 
             OR m1.order_process_date BETWEEN orderPerformFromDate AND orderPerformToDate)                           
        AND (repAttD IS NULL OR lower(m1.rep_code) ILIKE lower(repAttD) || '%')                                 
        AND (mobileNo IS NULL OR lower(m1.customer_phone) ILIKE lower(mobileNo) || '%')
        AND (demoPlan IS NULL OR lower(m1.demo_plan) ILIKE lower(demoPlan) || '%')        
        AND (demoFromDate IS NULL OR demoToDate IS NULL OR m1.demo_date BETWEEN demoFromDate AND demoToDate)            
        AND (itsHaveDiscount IS NULL OR lower(m1.its_have_discount) ILIKE lower(itsHaveDiscount) || '%')                     
        AND (orderStatus IS NULL OR lower(m1.register_status) ILIKE lower(orderStatus) || '%')                              
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)        
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterorderdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: getfilterpaymentdetailslist(character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterpaymentdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.order_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        payment_details m1
    WHERE
        (eNo IS NULL OR lower(m1.e_no) ILIKE lower(eNo) || '%') 
        AND (estNo IS NULL OR lower(m1.est_no) ILIKE lower(estNo) || '%') 
        AND (orderNo IS NULL OR lower(m1.order_no) ILIKE lower(orderNo) || '%')  
        AND (soNo IS NULL OR lower(m1.so_no) ILIKE lower(soNo) || '%')  
        AND (ddNo IS NULL OR lower(m1.d_d_no) ILIKE lower(ddNo) || '%')  
        AND (customerName IS NULL OR lower(m1.customer_name) ILIKE lower(customerName) || '%')        
        AND (orderPerformFromDate IS NULL OR orderPerformToDate IS NULL 
             OR m1.order_process_date BETWEEN orderPerformFromDate AND orderPerformToDate)                           
        AND (repAttD IS NULL OR lower(m1.rep_code) ILIKE lower(repAttD) || '%')                                 
        AND (mobileNo IS NULL OR lower(m1.customer_phone) ILIKE lower(mobileNo) || '%')
        AND (demoPlan IS NULL OR lower(m1.demo_plan) ILIKE lower(demoPlan) || '%')        
        AND (demoFromDate IS NULL OR demoToDate IS NULL OR m1.demo_date BETWEEN demoFromDate AND demoToDate)            
        AND (itsHaveDiscount IS NULL OR lower(m1.its_have_discount) ILIKE lower(itsHaveDiscount) || '%')                     
        AND (orderStatus IS NULL OR lower(m1.register_status) ILIKE lower(orderStatus) || '%')                              
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)        
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterpaymentdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id uuid NOT NULL,
    e_no character varying(255),
    est_no character varying(255),
    order_no character varying(255),
    so_no character varying(255),
    d_d_no character varying(255),
    customer_name character varying(255),
    billing_name character varying(255),
    billing_address text,
    customer_city character varying(255),
    customer_pin_code character varying(255),
    customer_phone character varying(255),
    customer_email character varying(255),
    rep_code character varying(255),
    demo_plan character varying(255),
    order_process_date timestamp without time zone,
    payment_charges character varying(255),
    payment_term_date timestamp without time zone,
    warranty character varying(255),
    pan_and_gst character varying(255),
    demo_date timestamp without time zone,
    delivery_address text,
    expected_date timestamp without time zone,
    ship_mode_name character varying(255),
    remarks text,
    total_product_amount character varying(255),
    gst character varying(255),
    delivery_charges character varying(255),
    total_amount character varying(255),
    less_advance character varying(255),
    balance character varying(255),
    register_status character varying(255),
    delivery_city character varying(255),
    delivery_pin_code character varying(255),
    demo_piece_estimate character varying(255),
    discount_amount character varying(255),
    discount_estimate character varying(255),
    its_have_discount character varying(255),
    stock_clearance_estimate character varying(255),
    payment_mode character varying(255),
    created_by character varying(255),
    created_date timestamp(6) without time zone
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- Name: getfilterpaymentsdetailslist(character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterpaymentsdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.payment_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        payment_details m1
    WHERE
        (eNo IS NULL OR lower(m1.e_no) ILIKE lower(eNo) || '%') 
        AND (estNo IS NULL OR lower(m1.est_no) ILIKE lower(estNo) || '%') 
        AND (orderNo IS NULL OR lower(m1.order_no) ILIKE lower(orderNo) || '%')  
        AND (soNo IS NULL OR lower(m1.so_no) ILIKE lower(soNo) || '%')  
        AND (ddNo IS NULL OR lower(m1.d_d_no) ILIKE lower(ddNo) || '%')  
        AND (customerName IS NULL OR lower(m1.customer_name) ILIKE lower(customerName) || '%')        
        AND (orderPerformFromDate IS NULL OR orderPerformToDate IS NULL 
             OR m1.order_process_date BETWEEN orderPerformFromDate AND orderPerformToDate)                           
        AND (repAttD IS NULL OR lower(m1.rep_code) ILIKE lower(repAttD) || '%')                                 
        AND (mobileNo IS NULL OR lower(m1.customer_phone) ILIKE lower(mobileNo) || '%')
        AND (demoPlan IS NULL OR lower(m1.demo_plan) ILIKE lower(demoPlan) || '%')        
        AND (demoFromDate IS NULL OR demoToDate IS NULL OR m1.demo_date BETWEEN demoFromDate AND demoToDate)            
        AND (itsHaveDiscount IS NULL OR lower(m1.its_have_discount) ILIKE lower(itsHaveDiscount) || '%')                     
        AND (orderStatus IS NULL OR lower(m1.register_status) ILIKE lower(orderStatus) || '%')                              
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)        
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterpaymentsdetailslist(eno character varying, estno character varying, orderno character varying, sono character varying, ddno character varying, customername character varying, orderperformfromdate timestamp without time zone, orderperformtodate timestamp without time zone, repattd character varying, mobileno character varying, demoplan character varying, demofromdate timestamp without time zone, demotodate timestamp without time zone, itshavediscount character varying, orderstatus character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: product_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_details (
    id uuid NOT NULL,
    product_id character varying(255),
    product_name character varying(255),
    product_category character varying(255),
    unit_price character varying(255),
    tax character varying(255),
    created_date timestamp without time zone,
    created_by character varying(255)
);


ALTER TABLE public.product_details OWNER TO postgres;

--
-- Name: getfilterproductdetailslist(character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterproductdetailslist(productid character varying, productname character varying, productcategory character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) RETURNS SETOF public.product_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m1.*
    FROM
        product_details m1
    WHERE
    (productId IS NULL OR lower(m1.product_id) ILIKE lower(productId) || '%')                         
        AND (productName IS NULL OR lower(m1.product_name) ILIKE lower(productName) || '%')      
        AND (productCategory IS NULL OR lower(m1.product_category) ILIKE lower(productCategory) || '%')        
        AND (createdFromDate IS NULL OR createdToDate IS NULL OR m1.created_date BETWEEN createdFromDate AND createdToDate)
        AND (createdBy IS NULL OR lower(m1.created_by) ILIKE lower(createdBy) || '%')
    ORDER BY
        m1.created_date DESC;
END;
$$;


ALTER FUNCTION public.getfilterproductdetailslist(productid character varying, productname character varying, productcategory character varying, createdfromdate timestamp without time zone, createdtodate timestamp without time zone, createdby character varying) OWNER TO postgres;

--
-- Name: user_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_details (
    id uuid NOT NULL,
    user_id character varying(255) NOT NULL,
    user_name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email_id character varying(255) NOT NULL,
    mobile_no character varying(255) NOT NULL,
    role_name character varying(255) NOT NULL,
    branch character varying(255) NOT NULL,
    rep_code character varying(255),
    rep_account character varying(255),
    user_rights text,
    leader_user_id character varying(255),
    file_name character varying(255)
);


ALTER TABLE public.user_details OWNER TO postgres;

--
-- Name: getfilterusersdetailslist(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfilterusersdetailslist(userid character varying, username character varying, mobileno character varying, rolename character varying, branchname character varying, repcode character varying, repaccount character varying, leaderuserid character varying) RETURNS SETOF public.user_details
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN QUERY
    SELECT 
        m1.*
    FROM
        user_details m1    
    WHERE
    m1.user_id IS NOT NULL
    AND lower(m1.user_id) ILIKE ANY(string_to_array(lower(userId) || '%', ','))
        AND lower(m1.user_name) ILIKE ANY(string_to_array(lower(userName) || '%', ','))
        AND lower(m1.mobile_no) ILIKE ANY(string_to_array(lower(mobileNo) || '%', ','))
        AND lower(m1.role_name) ILIKE ANY(string_to_array(lower(roleName) || '%', ','))
        AND lower(m1.branch) ILIKE ANY(string_to_array(lower(branchName) || '%', ','))
        AND lower(m1.rep_code) ILIKE ANY(string_to_array(lower(repCode) || '%', ','))
        AND lower(m1.rep_account) ILIKE ANY(string_to_array(lower(repAccount) || '%', ','))
        AND lower(m1.leader_user_id) ILIKE ANY(string_to_array(lower(leaderUserId) || '%', ','));        

END;

$$;


ALTER FUNCTION public.getfilterusersdetailslist(userid character varying, username character varying, mobileno character varying, rolename character varying, branchname character varying, repcode character varying, repaccount character varying, leaderuserid character varying) OWNER TO postgres;

--
-- Name: getfsmuseridsbaseddardetailslist(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfsmuseridsbaseddardetailslist(userids character varying) RETURNS SETOF public.dar_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    


    RETURN QUERY
    SELECT 
        m1.*
    FROM
        dar_details m1    
    WHERE
    lower(m1.created_by) ILIKE ANY(string_to_array(lower(userIds) || '%', ','))
     ORDER BY
        m1.created_date DESC;
        
END;

$$;


ALTER FUNCTION public.getfsmuseridsbaseddardetailslist(userids character varying) OWNER TO postgres;

--
-- Name: getfsmuseridsbasedestimationdetailslist(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfsmuseridsbasedestimationdetailslist(userids character varying) RETURNS SETOF public.estimation_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    


    RETURN QUERY
    SELECT 
        m1.*
    FROM
        estimation_details m1    
    WHERE
    lower(m1.created_by) ILIKE ANY(string_to_array(lower(userIds) || '%', ','))
     ORDER BY
        m1.created_date DESC;
        
END;

$$;


ALTER FUNCTION public.getfsmuseridsbasedestimationdetailslist(userids character varying) OWNER TO postgres;

--
-- Name: getfsmuseridsbasedorderdetailslist(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfsmuseridsbasedorderdetailslist(userids character varying) RETURNS SETOF public.order_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    


    RETURN QUERY
    SELECT 
        m1.*
    FROM
        order_details m1    
    WHERE
    lower(m1.created_by) ILIKE ANY(string_to_array(lower(userIds) || '%', ','))
    ORDER BY
        m1.created_date DESC;
END;

$$;


ALTER FUNCTION public.getfsmuseridsbasedorderdetailslist(userids character varying) OWNER TO postgres;

--
-- Name: getfsmuseridsbasedpaymentdetailslist(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getfsmuseridsbasedpaymentdetailslist(userids character varying) RETURNS SETOF public.payment_details
    LANGUAGE plpgsql
    AS $$
BEGIN
    


    RETURN QUERY
    SELECT 
        m1.*
    FROM
        payment_details m1    
    WHERE
    lower(m1.created_by) ILIKE ANY(string_to_array(lower(userIds) || '%', ','))
    ORDER BY
        m1.created_date DESC;
END;

$$;


ALTER FUNCTION public.getfsmuseridsbasedpaymentdetailslist(userids character varying) OWNER TO postgres;

--
-- Name: getuserbasedteammemberlist(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getuserbasedteammemberlist(leaderuserid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    result VARCHAR;
BEGIN
    -- Use recursive query to fetch the list of user IDs
    WITH RECURSIVE user_based_team_member_list AS (
        SELECT 
            user_id
        FROM 
            user_details
        WHERE 
            user_id = leaderUserId
        UNION 
        SELECT 
            ud.user_id
        FROM 
            user_details ud 
        INNER JOIN user_based_team_member_list s ON s.user_id = ud.leader_user_id
    )
    -- Concatenate all user IDs into a single string with commas
    SELECT string_agg(user_id::VARCHAR, ',') INTO result
    FROM user_based_team_member_list;

    -- Return the result
    RETURN result;
END;
$$;


ALTER FUNCTION public.getuserbasedteammemberlist(leaderuserid character varying) OWNER TO postgres;

--
-- Name: reset_user_id_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reset_user_id_sequence() RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
    last_user_id_num INT;
BEGIN    
    SELECT COALESCE(MAX(CAST(SUBSTRING(user_id FROM '^[^0-9]*(\d+)$') AS INTEGER)), 0) 
    INTO last_user_id_num
    FROM user_details
    WHERE user_id IS NOT NULL 
      AND user_id <> ''
      AND user_id ~ '^[^0-9]*(\d+)$'; 

    
    IF last_user_id_num IS NULL THEN        
        RETURN FALSE; 
    END IF;
    PERFORM setval('user_id_sequence', last_user_id_num);
    
    RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.reset_user_id_sequence() OWNER TO postgres;

--
-- Name: category_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_sequence OWNER TO postgres;

--
-- Name: dar_expenses_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dar_expenses_details (
    id uuid NOT NULL,
    reference_id character varying(255),
    expenses_description character varying(255),
    expenses_amount character varying(255),
    image_file_path character varying(255)
);


ALTER TABLE public.dar_expenses_details OWNER TO postgres;

--
-- Name: dar_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dar_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dar_sequence OWNER TO postgres;

--
-- Name: default_properties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.default_properties (
    id uuid NOT NULL,
    property_name character varying(255),
    property_value character varying(255)
);


ALTER TABLE public.default_properties OWNER TO postgres;

--
-- Name: estimation_product_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estimation_product_details (
    id uuid NOT NULL,
    reference_id character varying(255),
    product_details character varying(255),
    product_code character varying(255),
    qty integer,
    unit_price integer,
    tax integer,
    total double precision
);


ALTER TABLE public.estimation_product_details OWNER TO postgres;

--
-- Name: estimation_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estimation_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estimation_sequence OWNER TO postgres;

--
-- Name: order_product_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_product_details (
    id uuid NOT NULL,
    reference_id character varying(255),
    product_type character varying(255),
    product_details character varying(255),
    product_code character varying(255),
    qty integer,
    unit_price integer,
    tax integer,
    total double precision
);


ALTER TABLE public.order_product_details OWNER TO postgres;

--
-- Name: order_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_sequence OWNER TO postgres;

--
-- Name: product_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_sequence OWNER TO postgres;

--
-- Name: profile_image_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_image_details (
    id character varying(255) NOT NULL,
    file_path character varying(255),
    file_name character varying(255),
    file_type character varying(255),
    profile_type character varying(255)
);


ALTER TABLE public.profile_image_details OWNER TO postgres;

--
-- Name: user_id_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_sequence OWNER TO postgres;

--
-- Data for Name: dar_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dar_details (id, dar_no, dar_process_date, planned_activity, delivery_place_name_and_address, state_cum_area, client_name, client_mobile_no, about_the_client, product_details, from_location, to_location, total_expenses, status_to_visit, created_date, created_by) FROM stdin;
3d9055aa-4e12-4286-a2f6-7a0a868318c9	DAR_55	2024-10-10 05:30:00	asd	asd	as	asdf	asdf	sdf	asdf	asf	asdf	343444.00	Product delivered	2024-11-01 14:16:04.116	001
\.


--
-- Data for Name: dar_expenses_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dar_expenses_details (id, reference_id, expenses_description, expenses_amount, image_file_path) FROM stdin;
fb11206d-a7d1-4cc2-b7f7-1e0e9b63ae61	91e68726-7d6b-491f-8793-ca4f0e43595c	asdf	2	IMG-20240816-WA0007.jpg
63608b71-829f-4493-bdf4-574d93c4f573	91e68726-7d6b-491f-8793-ca4f0e43595c	asd	2	IMG-20240816-WA0006.jpg
8814bd75-d77c-4df8-94a9-10c6b5c7d120	91e68726-7d6b-491f-8793-ca4f0e43595c	asdf	2	IMG-20240816-WA0008.jpg
39ba37ac-a40e-4314-a4c9-a6dd3054dc3f	f3cbb8c6-e97d-4eb4-89b0-f961c50790ae	skjkfjs	10	Dashboard.png
595af904-8c15-498f-9515-3e2757992edb	f248db12-af57-455d-826c-446edaabb30b	asdf		Admin - Basaar Market — Mozilla Firefox 12-09-2024 12_15_38.png
2c97f0fa-4fc1-4faa-8033-a681bb578a9b	f248db12-af57-455d-826c-446edaabb30b	asdf		Cryptocurrency - Bootstrap 5 Admin Template — Mozilla Firefox 25-09-2024 11_59_09.png
16ef2256-014d-462a-b485-aca2430ad7da	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (1).png
c2ffa21b-5d71-4df2-8091-65d0ea68fa89	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (2).png
6c09e351-b11f-4cc1-bf5d-ef1fd2f8e391	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (3).png
3c163806-7ff5-4731-aafd-13098b4a0ab7	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (1).png
c69159a9-528d-4cba-b7d4-a78ee3b43bbe	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (2).png
7cf43456-2a24-4d42-aa33-a2994eb6b2e0	f248db12-af57-455d-826c-446edaabb30b	asdf		Screenshot (3).png
d7e12ae6-9cef-4bc7-8b92-a2098f8de18b	c7728c68-e1b3-4add-a8b9-94f2f9e4d271	Dgh	10	expense_image_1729859406855.jpg
fb53c03d-3af5-49e8-9af4-205bd02307e5	c7728c68-e1b3-4add-a8b9-94f2f9e4d271	Dgh	10	expense_image_1729859416407.jpg
9bf0eb5c-e5b0-46cc-b4fd-e4864b757bc7	b968c947-28e9-4fb9-a92d-829d7656ebdb	Dgh	10	expense_image_1729859645708.jpg
939e6f57-7e46-4379-b075-6a975c8c4c82	b968c947-28e9-4fb9-a92d-829d7656ebdb	Dgh	10	expense_image_1729859658980.jpg
3f8a31f2-f5df-4be6-82fe-02c8b7d9bfa5	b968c947-28e9-4fb9-a92d-829d7656ebdb	Dgh	10	expense_image_1729859689192.jpg
ad1e0bfa-814f-48be-a29c-c28239ea4f50	b968c947-28e9-4fb9-a92d-829d7656ebdb	Fjcjc	53568	expense_image_1729859689192.jpg
be83ddad-9df0-4434-bfa0-f3fa53eb56ba	b968c947-28e9-4fb9-a92d-829d7656ebdb	Dtg	20	expense_image_1729860269398.jpg
db9cc53a-79d8-4a1e-bd75-840841be5f64	c0bca5b6-a756-4e6a-bfa0-ea91305abf66	Bus	100	expense_image_1730097333214.jpg
090aa7dd-f673-4216-9ae2-b5e156ce477f	3d9055aa-4e12-4286-a2f6-7a0a868318c9	asdf		Cryptocurrency - Bootstrap 5 Admin Template — Mozilla Firefox 25-09-2024 11_59_09.png
\.


--
-- Data for Name: default_properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.default_properties (id, property_name, property_value) FROM stdin;
035e8cd3-b7c4-42fb-b303-a4139e3f6da1	DAR - Planned Activity	Demo,Delivery,Demo Cum Delivery,Installation,Service,Preventive Maintenance,BreakDown
f626e265-8f08-41af-97bd-f2b03a0d335f	Users - User Roles	RK,SRK,Sales coordinator,Sales Account,GS,VS,MK,MH,GB,YG,SR,Admin,REP
1fd255f0-4585-4f64-91f2-43da28fecfe8	DAR - Status To Visit	Demo success,Product Delivered
19cb16d8-4df6-49e0-a8a1-851b2e31b5fa	Estimation - Approval Status	,Estimation Enquiry,Cancel Estimation,Convert To Order,Not Matured
f3de67d9-fe95-4077-a055-d8a87003211a	Order - Approval Status	,New Order,Cancel Order,Partial Payment,Payment Confirmed
05ce9577-5ee6-4001-be49-484a27450e83	Payment - Approval Status	,Payment Confirmed,Payment Received
\.


--
-- Data for Name: estimation_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estimation_details (id, est_no, customer_name, estimation_process_date, rep_attd, rep_account, billing_address, delivery_address, customer_city, customer_pin_code, customer_phone, customer_email, delivery_city, delivery_pin_code, warranty, pan_and_gst, ref, remarks, its_have_discount, discount_estimate, demo_piece_estimate, stock_clearance_estimate, discount_amount, gst, delivery_charges, total_amount, register_status, created_by, created_date, total_product) FROM stdin;
d3043233-6447-42e8-8708-40c742fcc4ff	EST_26	Im	2024-10-28 05:30:00	123	123	Chennai, Tamil Nadu, India	Madurai, Tamil Nadu, India	Chennai, Tamil Nadu, India	123	1234566789	133@gmail.com	Madurai, Tamil Nadu, India	12334					No						20	420.00	Cancel Estimation	001	2024-11-10 01:51:24.346	400.00
2e4e4ab9-1343-4dbf-8b96-2ba0b4a28472	EST_14	Dgyhu	2024-10-24 05:30:00		123	Dhhh		Dghhj	Dgbhj	Fhhjj								Yes	34	34	34	3333		40	232.00	Not Matured	001	2024-11-11 12:01:33.792	200.00
\.


--
-- Data for Name: estimation_product_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estimation_product_details (id, reference_id, product_details, product_code, qty, unit_price, tax, total) FROM stdin;
e4635575-0228-43eb-a282-dd2086b4577a	\N	Product 2	S456	2	200	10	410
796ac033-90fa-405c-aa11-263cfff845fe	\N	Product 2	S456	2	200	10	410
12d83b3a-75ea-4f1a-b168-9879266542bf	\N	Product 2	S456	9	200	10	1810
21513f1a-fd59-4de0-bf28-117e6b14572f	2e4e4ab9-1343-4dbf-8b96-2ba0b4a28472	product 34	Asd	1	200	0	200
cc146637-d403-4525-a633-8eda9641e9fd	d3043233-6447-42e8-8708-40c742fcc4ff	product 34	123	2	200	0	400
2ef2e563-8732-4644-8684-542e5d439952	d3043233-6447-42e8-8708-40c742fcc4ff	product 11	12324	0	0	0	0
\.


--
-- Data for Name: order_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_details (id, e_no, est_no, order_no, so_no, d_d_no, customer_name, billing_name, billing_address, customer_city, customer_pin_code, customer_phone, customer_email, rep_code, demo_plan, order_process_date, payment_charges, payment_term_date, warranty, pan_and_gst, demo_date, delivery_address, expected_date, ship_mode_name, remarks, total_product_amount, gst, delivery_charges, total_amount, less_advance, balance, register_status, delivery_city, delivery_pin_code, demo_piece_estimate, discount_amount, discount_estimate, its_have_discount, stock_clearance_estimate, payment_mode, created_by, created_date) FROM stdin;
a50f1a1e-da39-472f-9b6b-5ca1ae7189c4		EST_25	ORD_62			124		Chennai, Tamil Nadu, India	Chennai, Tamil Nadu, India	124	22344	Fhnjk	123		2024-10-28 12:48:00.48		\N			\N	Madurai, Tamil Nadu, India	\N			200.00			200.00			New Order	Madurai, Tamil Nadu, India	1234				yes			\N	\N
b0cf1c00-a565-48f7-84ad-fdffc6f61f6d		EST_26	ORD_63			Im		Chennai, Tamil Nadu, India	Chennai, Tamil Nadu, India	123	1234566789	133@gmail.com	123	Yes	2024-10-28 17:32:34.696	Hi	2024-10-28 17:32:34.696	3years	123445	2024-10-28 17:32:34.696	Madurai, Tamil Nadu, India	2024-10-28 17:32:34.696			420.00			420.00	200	220.00	New Order	Madurai, Tamil Nadu, India	12334				No		neft	\N	\N
0d90eef4-8ff7-441a-853c-ad7919f04c33		EST_20	ORD_61			1234	asdf	asd	Fghhjj	Chjnnnn	Fhjjkk	Hjjkjk	123	No	2024-10-28 05:30:00	ASD	2024-10-31 05:30:00	2 Years	123	2024-10-28 05:30:00		2024-10-28 05:30:00		Dgjjj	4251.00		1	2100.00		2101.00	New Order	Cvbjj	Fhjjjk				no		cheque	001	2024-10-30 11:11:49.125
bd5fe119-519d-4bf9-bd58-5ac80cdbe7ec		EST_19	ORD_43			Him			Bnn	Vbnn	Cbnj	Vhjkk	123		2024-10-27 05:30:00		\N			\N		\N			0.00			0.00			Payment Confirmed	Xvn	Ghjn				no		cash	001	2024-11-09 16:52:05.509
45b3e6e5-0548-4369-a287-64a700495342		EST_16	ORD_41			Dghjjj		Dgjkk	Dghjkk	Fhjjk	Dhjkkk				2024-10-27 05:30:00		\N			\N		\N			0.00			70.00			Payment Confirmed									001	2024-11-09 17:56:59.457
4af8c757-b033-4ac9-b58f-8e257fd728a5		EST_12	ORD_39			Fghjj		Fghjj	Xghn	Xvbbh	Dgbbj				2024-10-27 05:30:00		\N			\N		\N			30.00		500	530.00			Payment Confirmed								cheque	001	2024-11-09 17:57:05.161
7ee1eff2-afe2-43a4-9ebf-edac26bb7784		EST_17	ORD_64			Cghnn		Dgbnn	Fhhnn	Dghnmjjn	Vnhvbbjj				2024-11-08 05:30:00		\N			\N		\N			0.00		20	50.00			Payment Confirmed						No			001	2024-11-10 04:02:38.699
\.


--
-- Data for Name: order_product_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_product_details (id, reference_id, product_type, product_details, product_code, qty, unit_price, tax, total) FROM stdin;
373353f2-8116-4358-a329-a67b67e6c931	74d944f3-7a82-4764-b7ea-8578fcd7d9f5		asdf	asd	2	2	3	7
5bc61535-f1b1-4f38-899d-bbce3fa4e4fe	74d944f3-7a82-4764-b7ea-8578fcd7d9f5		asdf	asdf	2	2	3	7
22e8772b-4889-4b8a-8e07-b9078d11f593	74d944f3-7a82-4764-b7ea-8578fcd7d9f5		asdf	asd	2	2	3	7
14688330-64d7-46b7-8f35-8d7746270353	070cdf76-58f6-4667-b1ed-4d28c525e8b0		asdf	asd	2	2	3	7
d8dff448-533d-4fc2-89b3-9ecc20740f39	070cdf76-58f6-4667-b1ed-4d28c525e8b0		asdf	asdf	2	2	3	7
f859e2ec-505c-4266-92ff-c30898fa210f	070cdf76-58f6-4667-b1ed-4d28c525e8b0		asdf	asd	2	2	3	7
7bb720f3-8554-4b91-a5df-aded42b31f9f	bd30f52b-fcc7-420e-89fa-5c002f7f8f6c				20	10	0	30
471e6d65-ff7d-4a5c-848f-6bed3b12263a	ff306b27-fd00-47be-a3f1-b7ec92c5b441		product 34	20344	10	100	0	200
5889ca9f-b0cf-4152-a9bb-435ea9d57899	e62cdf09-f807-4eae-bc24-45ce8ffae841				20	10	0	30
3be4ce67-2e76-475f-9af7-7b458e4151ce	fc307da2-e62f-45fb-bb55-306701d5ee1c		product 34	123	20	100	0	200
dfab1bd5-1e9f-4258-8ec9-a4a10c972e25	56c33991-86bb-488a-9999-6e706fa6cb8f				0	0	0	0
4c0f52c4-4999-4e23-8e95-fdccde314d17	4af8c757-b033-4ac9-b58f-8e257fd728a5				20	10	0	30
f18643d3-c351-4b41-b047-f6e9f2d9c7c2	3c722d94-d301-4058-bae1-68a0e446949f		product 34	20344	10	100	0	200
876d2be3-928e-41f5-bf7c-cbc1949fa01f	bd5fe119-519d-4bf9-bd58-5ac80cdbe7ec				0	0	0	0
397550e4-5d71-4d7d-8fa8-87f69c29e4d6	41d512f7-d812-4df4-bb99-138096470ae2				0	0	0	0
d965abd9-6d32-4c32-8e9a-c5802597793a	960c3d02-7db9-4e7b-b1bd-ddab2020436e		product 34	100	20	20	0	2000
883c13eb-5ec2-4a5b-92ad-8d6b6a2781c7	a50f1a1e-da39-472f-9b6b-5ca1ae7189c4		product 34	1	0	100	0	200
099a98c1-7ba7-4126-af8e-f9bb4e143bfd	b0cf1c00-a565-48f7-84ad-fdffc6f61f6d		product 34	123	2	200	0	400
c38d47b8-122a-4037-9494-5dd90558c2e0	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	product 34	100	20	20	0	2000
66aa4dfd-633a-4299-aa86-d4efe79dc9b6	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	product 34	PDT_5	0	34	343	343
1f92e2a6-621f-4192-96eb-a10252c72b3b	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	product 34	PDT_5	0	34	343	343
5e83af7a-6109-4f63-bbf5-6ab692685f13	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	asd	PDT_6	0	34	343	343
bd6c3390-5285-4f06-9c67-67eb44817761	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	sf		0	0	3	3
777b6222-c900-45b9-b674-9d6e19f18733	0d90eef4-8ff7-441a-853c-ad7919f04c33		product 11	PDT_4	0	78	873	873
f494b2fd-8ace-4e25-ba2b-a27b9f21ea8b	0d90eef4-8ff7-441a-853c-ad7919f04c33		asd	PDT_6	0	34	343	343
41d1a937-7421-4018-ab80-0e52ec9ffa76	0d90eef4-8ff7-441a-853c-ad7919f04c33		asdf		0	0	3	3
bcca84f2-ee02-479d-a41b-293750585d83	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	product 11	PDT_4	0	78	87	0
27e0138d-3ade-4818-9bae-8c9f10b1473d	0d90eef4-8ff7-441a-853c-ad7919f04c33	stock	asd	PDT_6	0	34	34	0
de1d47d7-4dab-432d-9918-b4dd75957676	7ee1eff2-afe2-43a4-9ebf-edac26bb7784	Stock	Rajesh	PDT_3	0	343	343	0
45e04dc2-c929-40f8-9207-817053ed02a8	7ee1eff2-afe2-43a4-9ebf-edac26bb7784	Stock	product 11	PDT_4	0	78	87	0
50525d7a-59f7-42f9-8652-905bfc681753	7ee1eff2-afe2-43a4-9ebf-edac26bb7784	Stock	product 11	PDT_4	0	78	87	0
a24fb5b9-a632-4606-8713-1c4bbef59143	7ee1eff2-afe2-43a4-9ebf-edac26bb7784	Stock	product 34	PDT_5	0	34	34	0
dc1082d2-f407-40a6-8694-b51d8c3f3787	7ee1eff2-afe2-43a4-9ebf-edac26bb7784	Stock	product 11	PDT_4	0	78	87	0
\.


--
-- Data for Name: payment_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_details (id, e_no, est_no, order_no, so_no, d_d_no, customer_name, billing_name, billing_address, customer_city, customer_pin_code, customer_phone, customer_email, rep_code, demo_plan, order_process_date, payment_charges, payment_term_date, warranty, pan_and_gst, demo_date, delivery_address, expected_date, ship_mode_name, remarks, total_product_amount, gst, delivery_charges, total_amount, less_advance, balance, register_status, delivery_city, delivery_pin_code, demo_piece_estimate, discount_amount, discount_estimate, its_have_discount, stock_clearance_estimate, payment_mode, created_by, created_date) FROM stdin;
4af8c757-b033-4ac9-b58f-8e257fd728a5		EST_12	ORD_39			Fghjj		Fghjj	Xghn	Xvbbh	Dgbbj				2024-11-09 17:57:05.18		\N			\N		\N			530.00		500	530.00			Payment Received								\N	001	2024-11-09 19:56:11.202
7ee1eff2-afe2-43a4-9ebf-edac26bb7784		EST_17	ORD_64			Cghnn		Dgbnn	Fhhnn	Dghnmjjn	Vnhvbbjj				2024-11-10 04:02:38.814		\N			\N		\N			50.00		20	50.00			Payment Confirmed						No		\N	001	2024-11-10 04:02:38.699
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, category_id, category, created_date, created_by) FROM stdin;
f93a5626-8d64-4c98-b294-89c58a3a62d1	3434	Category1	2024-11-07 14:24:06.022	001
94912010-0d11-4335-a0ce-a2ea757d5168	123	Category2	2024-11-07 14:24:15.374	001
\.


--
-- Data for Name: product_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_details (id, product_id, product_name, product_category, unit_price, tax, created_date, created_by) FROM stdin;
38e63417-1ae3-42e3-b5b2-7fcb2886e1de	PDT_3	Rajesh	Category2	343	343	2024-10-23 16:01:33.43	001
1397305a-24fe-47ea-a09c-12f3f8d2c48e	PDT_4	product 11	Category1	78	87	2024-10-24 14:28:51.515	001
16d4dfbc-595b-4862-b358-eec68f3b95e0	PDT_5	product 34	Category1	34	34	2024-10-24 14:29:04.578	001
7028d63b-b435-499c-bd2c-9b5acf5fc848	PDT_6	asd	Category1	34	34	2024-10-29 15:18:12.587	001
ee82fb18-1013-4edc-8e97-2609c8d73962	0002	asdf	Category1	9	9	2024-10-29 15:49:20.749	001
\.


--
-- Data for Name: profile_image_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profile_image_details (id, file_path, file_name, file_type, profile_type) FROM stdin;
\.


--
-- Data for Name: user_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_details (id, user_id, user_name, password, email_id, mobile_no, role_name, branch, rep_code, rep_account, user_rights, leader_user_id, file_name) FROM stdin;
917f318b-ade8-41a8-a740-00364443f095	USR_4	Sam	123	yhdhdnn	7878787878	VS	Chennai	123	123	{"DAR":"","Estimation":""}	001	USR_4_Screenshot (8).png
e0717635-e7ee-4788-976d-1a0c99e9e5cc	001	Admin	123	admin@gmail.com	9090909090	SRK	Chennai	-	-	{"Dashboard":"","Users":"","Catgory":"","Product":"","DAR":"","Estimation":"","Order":"","Payment":"","Default Properties":""}		001_Screenshot (4).png
\.


--
-- Name: category_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_sequence', 2, true);


--
-- Name: dar_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dar_sequence', 55, true);


--
-- Name: estimation_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estimation_sequence', 26, true);


--
-- Name: order_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_sequence', 64, true);


--
-- Name: product_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sequence', 6, true);


--
-- Name: user_id_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_sequence', 5, true);


--
-- Name: dar_details dar_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dar_details
    ADD CONSTRAINT dar_details_pkey PRIMARY KEY (id);


--
-- Name: dar_expenses_details dar_expenses_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dar_expenses_details
    ADD CONSTRAINT dar_expenses_details_pkey PRIMARY KEY (id);


--
-- Name: default_properties default_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_properties
    ADD CONSTRAINT default_properties_pkey PRIMARY KEY (id);


--
-- Name: estimation_details estimation_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estimation_details
    ADD CONSTRAINT estimation_details_pkey PRIMARY KEY (id);


--
-- Name: estimation_product_details estimation_product_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estimation_product_details
    ADD CONSTRAINT estimation_product_details_pkey PRIMARY KEY (id);


--
-- Name: order_details order_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_details
    ADD CONSTRAINT order_details_pkey PRIMARY KEY (id);


--
-- Name: order_product_details order_product_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product_details
    ADD CONSTRAINT order_product_details_pkey PRIMARY KEY (id);


--
-- Name: payment_details payment_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_details_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_details product_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_details
    ADD CONSTRAINT product_details_pkey PRIMARY KEY (id);


--
-- Name: profile_image_details profile_image_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_image_details
    ADD CONSTRAINT profile_image_details_pkey PRIMARY KEY (id);


--
-- Name: user_details user_details_mobile_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_details
    ADD CONSTRAINT user_details_mobile_no_key UNIQUE (mobile_no);


--
-- Name: user_details user_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_details
    ADD CONSTRAINT user_details_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

