CREATE PROCEDURE [dbo].[CalcFractionAfterMove]
	@nodeId BIGINT,
	@m BIGINT, -- mth child of new parent
	@newNv BIGINT = NULL OUTPUT,
	@newDv BIGINT = NULL OUTPUT,
	@newSnv BIGINT = NULL OUTPUT,
	@newSdv BIGINT = Null OUTPUT
AS
	-- m1 = p1 X [ 1, 0, (m-n), 1 ] X p0^-1 X m0

	-- m0 is the node's matrix before the move
	-- m1 is the node's matrix after the move
	-- p0 is the node's parent's matrix
	-- p1 is the new parent's matrix
	-- m 

	DECLARE 
		@parentNodeId BIGINT, @n BIGINT,

		-- m0
		@m0nv BIGINT, @m0dv BIGINT, @m0snv BIGINT, @m0sdv BIGINT,

		-- m1
		@m1nv BIGINT, @m1dv BIGINT, @m1snv BIGINT, @m1sdv BIGINT,

		-- p0
		@p0nv BIGINT, @p0dv BIGINT, @p0snv BIGINT, @p0sdv BIGINT,

		-- p1
		@p1nv BIGINT, @p1dv BIGINT, @p1snv BIGINT, @p1sdv BIGINT,

		-- step1
		@step1nv BIGINT, @step1dv BIGINT, @step1snv BIGINT, @step1sdv BIGINT,

		-- step2
		@step2nv BIGINT, @step2dv BIGINT, @step2snv BIGINT, @step2sdv BIGINT,

		-- step3
		@step3nv BIGINT, @step3dv BIGINT, @step3snv BIGINT, @step3sdv BIGINT

		-- lookup what we need

		-- first node's parent id
		-- i am deliberately not using [parent_node_id] here, instead we use the algorithm
		SELECT @parentNodeId = [parent_node_id] FROM GetAncestors(@nodeId, 1)

		-- then node
		SELECT 
			@m0nv = m0.[nv],
			@m0dv = m0.[dv],
			@m0snv = m0.[snv],
			@m0sdv = m0.[sdv]
		FROM [Node] as m0
		WHERE m0.[node_id] = @nodeId

		-- then n (node is the nth child of its parent)
		SELECT @n = COUNT([node_id]) 
		FROM GetDescendants(@parentNodeId)
		WHERE (CAST([nv] AS FLOAT) / [dv]) < (CAST(@m0nv AS FLOAT) / @m0dv)
		ORDER BY (CAST([nv] AS FLOAT) / [dv]) ASC

		-- then its current parent
		SELECT 
			@p0nv = p0.[nv],
			@p0dv = p0.[dv],
			@p0snv = p0.[snv],
			@p0sdv = p0.[sdv]
		FROM [Node] as p0
		WHERE p0.[node_id] = @parentNodeId

		-- then the new parent
		SELECT 
			@p1nv = p1.[nv],
			@p1dv = p1.[dv],
			@p1snv = p1.[snv],
			@p1sdv = p1.[sdv]
		FROM [Node] as p1
		WHERE p1.[node_id] = @parentNodeId

		-- order counts in matrix multiplication

		-- step1 = p1 X [ 1, 0, (m-n), 1 ]
		EXECUTE [MatrixMultiply2x2]
			-- p1
			@a11 = @p1nv,
			@a21 = @p1dv,
			@a12 = @p1snv,
			@a22 = @p1sdv,

			-- [  1,	0, 
			--  (m-n),	1 ]
			@b11 = 1,
			@b21 = -999/*m - n*/,
			@b12 = 0,
			@b22 = 1,

			@ab11 = @step1nv,
			@ab21 = @step1dv,
			@ab12 = @step1snv,
			@ab22 = @step1sdv

		-- step2 = step1 X p0^-1
		EXECUTE [MatrixMultiply2x2]
			-- step1
			@a11 = @p1nv,
			@a21 = @p1dv,
			@a12 = @p1snv,
			@a22 = @p1sdv,

			-- [  1,	0, 
			--  (m-n),	1 ]
			@b11 = 1,
			@b21 = -999/*m - n*/,
			@b12 = 0,
			@b22 = 1,

			@ab11 = @step1nv,
			@ab21 = @step1dv,
			@ab12 = @step1snv,
			@ab22 = @step1sdv

		-- step3 = step2 X m0

RETURN 0
