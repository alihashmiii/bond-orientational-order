func[image_] := 
 CreatePalette[
  DynamicModule[{segmentImage, showFunc, deleteFalsePts, addPts, packagedFunction, img = image, ovimg, data},
   Grid[{
     {Button["create Voronoi", packagedFunction[data], 
       Method -> "Queued"]} ,
     {Button["particle centroids", CreateDocument[{
         TextCell["Coordinate List", "Title"],
         TextCell[
          Row[{"Report generated @ ", DateString[], "\n", 
            "Particles #: ", Length@data}], "Text"],
         ExpressionCell[data, "Output"]
         }]
       ]} ,
     {Pane[
       Dynamic@If[Head[img] === Image,
         LocatorPane[
          Dynamic@data, 
          DynamicImage[ovimg, AppearanceElements -> {"Zoom", "Scrollbars"}], 
          LocatorAutoCreate -> All, Appearance -> Style["*", 20, Red]]
         ]
       ]
      }
     }],
   Initialization :> (
     segmentImage[img_, circ_: 0.95, thresh_: {10, 50}] := 
      SelectComponents[
          ColorNegate@DeleteSmallComponents@MorphologicalBinarize@img, (First[thresh] <= #Count < 
              Last[thresh] && #Circularity > circ) &] // MorphologicalComponents // 
        ComponentMeasurements[#, "Centroid"] & // Values;
     data = segmentImage@img;
     
     showFunc[img_, pts_] := Show[img, Graphics[{XYZColor[0, 0, 1, 0.4], Thickness[0.005], Circle[#, 8] & /@ pts}]];
     ovimg = showFunc[img, data];
     
     packagedFunction[pts_?(Length@# > 1 &)] := Block[{delMesh, vertexcoords, vertexconn, cellNeighCoords, angles, anglesC, poly,
      pos, polyOrdered, colourVM, regMemQ},
       delMesh = DelaunayMesh@pts;
       vertexcoords = <| delMesh["VertexCoordinateRules"] |>;
       vertexconn = delMesh["VertexVertexConnectivityRules"];
       cellNeighCoords = With[{vertexpts = vertexcoords},
         FlattenAt[{Lookup[vertexpts, Keys@#],Lookup[vertexpts, Values@#]}, {2}] & /@ vertexconn
        ];
       angles = (Abs[(Plus @@ Exp[6.0 I #])/Length@#]) & /@ 
         Map[Map[x \[Function] VectorAngle[{1, 0}, First[#] - x ], Rest@#] &, cellNeighCoords];
       anglesC = ColorData["TemperatureMap", #] & /@ angles;
       poly = MeshPrimitives[VoronoiMesh[pts, None], 2];
       regMemQ = RegionMember /@ poly;
       pos = Position[Through[regMemQ[#]], True] & /@ pts;
       polyOrdered = Extract[poly, pos];
       colourVM = MapThread[{#2, #1} &, {Thread[{EdgeForm[Black], polyOrdered}], anglesC}];
       CreateDocument[ExpressionCell[Graphics[{colourVM, Point@pts}], Automatic]]
       ];
     )
   ],
  WindowTitle -> "BondOrientationalOrder"]

(* call func *)

With[{imgs = Import@"C:\\Users\\aliha\\Downloads\\Movie_95.tif" },
 deploy[num_] := func@Part[imgs, num]
 ]

deploy[1]
