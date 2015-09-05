CREATE PROCEDURE InsertNode(
	@parentNodeId BIGINT,
	@name NVARCHAR(64),
	@newNodeId BIGINT = NULL OUTPUT
)
AS
	SET NOCOUNT ON
	-- we'll sanitize parentNodeId NULL to be same AS 0, which is the root/reserved [Node]
	if (@parentNodeId = NULL)
		SET @parentNodeId = 0

	DECLARE @nvp BIGINT = -1
	DECLARE @dvp BIGINT
	DECLARE @snvp BIGINT
	DECLARE @sdvp BIGINT
	DECLARE @c BIGINT

	-- Hazel (2008)
	-- Adding nv to snv gives the numerator of the first child
	-- Adding dv to sdv gives the denominator of the first child
	-- given the nv, dv, snv and sdv of a parent [Node] p, we can determine the nv and dv of its cth child as follows:
	-- nvc = nvp + c × snvp (2.1)
	-- dvc = dvp + c × sdvp (2.2)
	-- Since the next sibling of the cth child of [Node] p, is the (c + 1)th child of [Node] p, it follows that
	-- snvc = nvp + (c + 1) × snvp (2.3)
	-- sdvc = dvp + (c + 1) × sdvp (2.4)

	-- read the parent's fractions
	-- todo: what does this do if parent no exist
	SELECT
		@nvp = n.[nv],
		@dvp = n.[dv],
		@snvp = n.[snv],
		@sdvp = n.[sdv]
	FROM [Node] AS n
	WHERE n.[node_id] = @parentNodeId

	--print '@nvp = ' + cast(@nvp AS NVARCHAR)
	--print '@dvp = ' + cast(@dvp AS NVARCHAR)
	--print '@snvp = ' + cast(@snvp AS NVARCHAR)
	--print '@sdvp = ' + cast(@sdvp AS NVARCHAR)

	DECLARE @pf FLOAT = @nvp / @dvp
	DECLARE @psf FLOAT = @snvp / @sdvp

	--print 'nvp / dvp = ' + cast(@pf AS NVARCHAR)
	--print 'snvp / sdvp = ' + cast(@psf AS NVARCHAR)

	-- find the next child (c) to insert under parent
	-- todo: i bet you could do calc the fractions and do this in one statement... faster?
	SELECT @c = COUNT(n.node_id) + 1
	FROM [Node] AS n
	WHERE 
		(cast(n.[nv] AS FLOAT) / n.[dv]) > (cast(@nvp AS FLOAT) / @dvp) 
		and 
		(cast(n.[nv] AS FLOAT) / n.[dv]) < (cast(@snvp AS FLOAT) / @sdvp) 

	--print '@c = ' + cast(@c AS NVARCHAR)

	INSERT INTO [Node] 
	SELECT 
		@name,
		p.[nv] + @c * p.[snv], -- nvc
		p.[dv] + @c * p.[sdv], -- dvc
		p.[nv] + (@c + 1) * p.[snv], -- svnc
		p.[dv] + (@c + 1) * p.[sdv], -- sdv
		p.[depth] + 1,
		p.[node_id]
	FROM [Node] AS p
	WHERE p.[node_id] = @parentNodeId

	SET @newNodeId = scope_identity()
RETURN
