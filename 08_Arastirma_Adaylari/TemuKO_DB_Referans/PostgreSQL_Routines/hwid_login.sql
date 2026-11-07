CREATE FUNCTION dbo.hwid_login(v_accountid character varying, v_mac integer, v_hwid bigint) RETURNS smallint
    LANGUAGE plpgsql
    AS $$ BEGIN RETURN 1; END; $$;


--
-- Name: knights_alliance_load(); Type: FUNCTION; Schema: dbo; Owner: -
--

CREATE FUNCTION dbo.knights_alliance_load() RETURNS TABLE(out_smainallianceknights smallint, out_ssuballianceknights smallint, out_smercenaryclan_1 smallint, out_smercenaryclan_2 smallint, out_stralliancenotice text)
    LANGUAGE plpgsql
    AS $$
BEGIN
-------------------------------------------------------------------------------------------------------
RETURN QUERY SELECT sMainAllianceKnights,sSubAllianceKnights,sMercenaryClan_1,sMercenaryClan_2,strAllianceNotice FROM KNIGHTS_ALLIANCE;
-------------------------------------------------------------------------------------------------------
--TheThyke
END;
$$;