CREATE FUNCTION GetAncestors(
	@nodeId BIGINT,
	@numGenerations INT
) returns @ancestortable TABLE (
	node_id BIGINT NOT NULL,
	name NVARCHAR(64) NOT NULL,
	nv BIGINT NOT NULL, 
	dv BIGINT NOT NULL,
	snv BIGINT NOT NULL,
	sdv BIGINT NOT NULL,
	depth INT NOT NULL,
	parent_node_id BIGINT NOT NULL)
AS
begin
	DECLARE @ancnv BIGINT = 0
	DECLARE @ancdv BIGINT = 1
	DECLARE @ancsnv BIGINT = 1
	DECLARE @ancsdv BIGINT = 0
	DECLARE @div BIGINT
	DECLARE @mod BIGINT
	DECLARE @numerator BIGINT
	DECLARE @denominator BIGINT
	DECLARE @depth INT

	SELECT
		@numerator = n.[nv],
		@denominator = n.[dv],
		@depth = n.[depth]
	FROM [Node] AS n
	WHERE n.[node_id] = @nodeId
	
	-- todo: loop appears to include [Node] itself
	while @numerator > 0 and @denominator > 0
	begin
		SET @div = @numerator / @denominator
		SET @mod = @numerator % @denominator
		SET @ancnv = @ancnv + @div * @ancsnv
		SET @ancdv = @ancdv + @div * @ancsdv
		SET @ancsnv = @ancnv + @ancsnv
		SET @ancsdv = @ancdv + @ancsdv
		
		insert into @ancestortable
		SELECT node_id, name, nv, dv, snv, sdv, depth, parent_node_id
		FROM [Node]
		WHERE 
			nv = @ancnv 
			and dv = @ancdv
			and node_id <> @nodeId
			and (@numGenerations = -1 or depth >= @depth - @numGenerations)
		
		SET @numerator = @mod
		
		if @numerator <> 0
		begin
			SET @denominator = @denominator % @mod
			if @denominator = 0
			begin
				SET @denominator = 1
			end
		end
	end
	RETURN
end
