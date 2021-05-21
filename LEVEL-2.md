Blender donut tutorial notebook - level 2
=========================================

This carries on my notebook for the [Blender donut tutorial](https://www.youtube.com/watch?v=TPrnSACiTJ4&list=PLjEaoINr3zgEq0u2MzVgAaHEBt--xLB6U). There first part of the notebook is [here](README.md) and covers level 1. This part covers level 2.

Level 2, Part 1 - particles
---------------------------

Return to the _Layout_ workspace if you're still in _Compositing_ and to the simple _Solid_ _Viewport Shading_ rather than _Rendered_.

### Organize your Outliner

The _Scene Collection_ (upper-right corner) is actually part of the _Editor Type_ called _Outliner_. We already created the _Archive_ collection there that we can exclude from the view layer. So let's do the same for everything else and clean up the _Outliner_ to make everything more manageable:

* Select both donut and icing, add press `m` (for move) and add a _New Collection_ that's also called "Donut" - this seems a bit stupid, i.e. a collection with a single thing in it, but we can exclude the collection from the view layer (via the checkbox beside the eye icon) as well as just hiding it (the eye icon). An excluded item is excluded from any render whereas a hidden item is just hidden in the viewport.
* Select the plane and add it to a new collection called "Environment".
* Rename the original _Collection_ (which should now just contain the _Camera_ and _Light_) to "Camera and light"

![img.png](collection-organized.png)

**Important:** I kept on selecting just the donut body in the viewport and then pressing `m` - this resulted in the real icing being left behind in the original collection with the donut ending up in the new collection with just some kind of ghost-like link to its icing child. See the _Icing_ under _Collection_ here and the greyed out _Icing_ child of _Donut_:

![img.png](collection-mistake.png)

Even if you select the donut parent in the _Scene Collection_, you still also have to control-click the upside down triangle, corresponding to the icing object, before pressing `m`.

### Create the first sprinkle

First exclude all collections (Andrew says "hide" but he means exclude), i.e. untick the checkboxes for the "Camera and light", "Donut" and "Environment" collections.

First, `shift-A` and under _Mesh_, add a _UV Sphere_ (what U and V mean is a little complicated, see the Wikipedia [_UV mapping_](UV mapping) page and for the difference, again quite complicated, between _UV Shere_ and _Icosphere_, see this StackExchange [question](https://blender.stackexchange.com/q/72)). Then before you click away, go to the _Add UV Sphere_ dialog (lower-right) and change the _Radius_ from 1m to 1mm and adjust down _Segments_ to 12 and _Rings_ to 6 (otherwise your render times will be terrible once you've got hundreds of sprinkles on your icing).

**Note:** clipping came up before very early on, here when I zoomed in on the sphere it disappeared as I got close. This can be resolved by pressing `n` to pop out the side menu, selecting the _View_ tab and changing the _Clip Start_ to 1mm. Make sure you're not in camera view as it has its own clipping settings and will still clip even if you adjust _Clip Start_.

Unexclude the "Donut" collection, press `Numpad-0` (front view), select the sphere, then `g` and `x` and drag it off to the left of the donut:

![img.png](donut-and-sphere.png)

`tab` into _Edit Mode and toggle on x-ray - `alt-Z` - and select the top half of the sphere. Then `g` and try moving it:

![img.png](sphere-grab.png)

**Important:* make sure proportional is off or you'll just end up dragging the whole sphere (because the proportional area of influence extends over the whole tiny sphere).

So simple `g` isn't quite what we want, cancel and use `e` (for extrude) instead:

![img.png](sphere-extruded.png)

Then with the top of the sphere still selected, press `s` and `z` and drag the mouse up and down to flatten the end a bit. Then select the bottom half and do the same:

![img.png](sphere-flattened-ends.png)

`tab` back to _Object Mode_, toggle off x-ray - `alt-Z`, right-click on the sprinkle and select _Shade Smooth_.

Note: oddly, if you haven't got the sprinkle currently selected, you can right click on it and select _Shade Smooth_ but it does nothing.

![img.png](sprinkle-shade-smooth.png)

### Particle instances

Particle instances is where you reference one object and duplicate it over the surface of another object.

Select the icing, go to _Particle Properties_ and for whatever reason there's no _New_, instead click the plus icon and then press _Play Animation_ (as for the monkey head fire animation) and you get a very strange particle effect. So switch from the default _Emitter_ particle type (animated) to _Hair_ type (static) for an initially even weirder static effect:

![img.png](emitter.png)

Then expand the _Render_ section of the _Particle Properties_ and switch _Render As_ from a _Path_ (i.e. essentially a hair) to an _Object_, then click the eye dropper in the _Instance Object_ field and select the sprinkle:

![img.png](instance-object.png)

Then adjust the _Scale_ value (under where you just set _Render As_) to e.g. 1.6 and set _Scale Randomness_ to a tiny value e.g. 0.1 or just leave it alone.

Andrew notes that you'd use particles like this to scatter rocks over a scene but there you'd crank up _Scale Randomness_ to create far more variation in rock sizes.

As you can see the sprinkles are all facing the same direction, so tick _Advanced_ and tick, expand the _Rotation_ section and change _Orientation Axis_ from _Velocity / Hair_ to _Normal_. Now, try adjusting _Randomize - interesting but this clearly isn't what we want - then trying adjusting _Randomize Phase_.

Set _Randomize Phase_ to maximum and then set _Randomize_ to a tiny value, e.g. 0.15, as you don't want all the sprinkles lying perfectly on the surface, you want some to turn a little randomly relative to the surface as they would when sinking into the icing.

Try adjusting _Randomize_ up and down - you'll notice something odd, it's looks as if the center of gravity of each sprinkle is one of its ends rather that its middle - this will be addressed in the next lesson.

Aside: Andrew notes that it's a bit odd that the random settings are under _Advanced_ as he always uses them.

### Weight painting

Hide the donut (but not the icing) by unselecting its eye icon and you'll see there are sprinkles on the underside of the icing (and also on the the sides and dribbles where real sprinkles wouldn't usually stick):

![img.png](sprinkles-on-under-surface.png)

Unhide the donut, go to the dropdown where you see _Object Mode_ and change it to _Weight Paint_. Unlike _Edit Mode_, you can't just `tab` to this mode, but you can press `ctrl-tab` to bring up a pie menu and select _Weight Paint_.

Just click and paint on the blue, blue means zero, i.e. no sprinkles later , and red means one, i.e. maximum:

![img.png](weight-paint.png)

Redrawing the particles while painting can be quite compute intensive and slow things down, so you can turn them off temporarily while painting by unselecting the little monitor icon (beside the camera and the plus in the _Particle Properties_).

![img.png](disable-realtime-particles.png)

As with sculpting, you can adjust the brush radius with `f` - Andrew uses a radius of about 270px. Draw a big fat circle on the top of the icing, then adjust the radius down, e.g. to 150px, and flip the _Weight_ value between 1 (to draw in red) and 0 to draw in blue to get exactly the coverage you want:

![img.png](weight-paint-complete.png)

Re-enable the sprinkles (monitor icon) and switch back to _Object Mode_ - interestingly, `tab` would switch to _Edit Mode_ but then `tab` again would switch back to _Weight Mode_, i.e. `tab` toggles between _Edit Mode_ and the previously selected mode. So use `ctrl-tab` instead.

Nothing has changed, to get the particles to use the weight painting, go to _Particle Properties, then go right down and expand _Vertex Groups_ and set _Density_ to _Group_:

![img.png](vertex-groups.png)

I had to go back and adjust the weight painting until I was happy there weren't too many sprinkles close to the edges of the icing where it's steepest.

Note: you can just go back to _Weight Paint_ mode and work with the weight painting but if you've got the icing selected, you can also go to _Object Data Properties_ and you'll see it under _Vertex Groups_ with the default name _Group_. Go into _Weight Paint_ mode and click minus to remove this vertex group and see what happens (then press `ctrl-Z` to undo this).

![img.png](weight-paint-vertex-group.png)

If you feel you got too many sprinkles, go back to _Particle Properties_ and in the _Emission_ section, adjust the _Number_ value down to e.g. 700.

Update: you can see he settles on 800 much later on.

If you do a render now, things will look very strange until you un-exclude the collections for camera, light and environment (and make sure you've got the camera looking at what you want).

Level 2, Part 2 - random materials
----------------------------------

Make sure you're in _Object Mode_ and switch from _Solid_ viewport shading to _Rendered_ (with `z` pie menu). Does your donut look very weird?:

![img.png](unlit-donut.png)

To correct this, just un-exclude the camera and light collection (but leave the environment collection excluded).

To change the color for the currently tic-tac-like sprinkles, select the original single sprinkle (off to the side of the donut), go to _Material Properties_, click _New_ and set _Base Color_ to HSV 0.6, 0.7 and 0.9, you'll end up with all blue sprinkles:

![img.png](blue-sprinkles.png)

### Random set of colors

Now switch to _Solid_ viewport shading (`z` and `6`) and click the _Shading_ button in the main menu bar. The resulting workspace looks quite strange:

![img.png](shading-workspace.png)

In particular, the background is quite odd - you see a very blurry version of the outdoor scene that you can see in the mirrored sphere. And the donut is almost invisible - but you can see the 3D cursor that marks its center. Just zoom-in on the donut to bring it into view.

**Important:** we're now in the _Shading_ workspace but we've already been working with _Viewport Shading_, which is something different, i.e. the _Solid_, _Rendered_ etc. discs that you see in the upper-right of the viewport. Look at which of the _Viewport Shading_ discs is currently selected - it's _Material Preview_ - when we switched to the _Shading_ workspace, it automatically switched from _Rendered_ to this. To the right of the _Viewport Shading_ discs is a drop-down arrow - it reveals options specific to the currently selected _Viewport Shading_ mode. Try it and you'll see these options for _Material Preview_:

![img.png](material-preview-options.png)

The [documentation](https://docs.blender.org/manual/en/latest/editors/3dview/display/shading.html) is a little confusing - the mirrored sphere is what's referred to in the documentation as the _HDRI Environment_, i.e. the "environment map used to light the scene". It, _Rotation_, _Strength_, _World Opacity_ and _Blur_ only come into play if _Scene World_ is unticked (as it is by default in Blender 2.92). Try clicking on the sphere and choosing a different environment map and try reducing _Blur_ to zero to the environment far more clearly.

In the video it _looks_ as if there's no environment showing. You can get a similar look to this by ticking both _Scene Lights_ and _Scene World_ but then the mirrored sphere disappears from the viewport. Alternatively, you can set _World Opacity_ to 0 to get something that looks similar to Andrew's setup. However, it may simply be that he's zoomed in such that we no longer see much structure in the environment map. I left all viewport shading options unchanged.

Note: what Andrew refers to as "LookDev mode" has been renamed to _Material Preview_ (see [here](https://developer.blender.org/T68312) - there, they also note that the intention was to remove _Scene Lights_ and _Scene World_ but other people argued to keep them).

Select the original sprikle so that its nodes show up in the _Shader Editor_, notice how the contents of the _Principled BSDF_ node are identical to those in the _Shading_ section of the _Material Properties_:

![img.png](bsdf-node.png)

The node view is another view on these same properties where you can use and manipulate them in a far more advanced way. If you adjust values in the node view, you'll see those changes reflected in the _Material Properties_ and vice-versa.

Aside: what does _BSDF_ stand for? See [here](https://en.wikipedia.org/wiki/Bidirectional_scattering_distribution_function) on Wikipedia and [here](https://blender.stackexchange.com/a/786) on the Blender StackExchange for an answer.

We want to add a node that will set the _Base Color_ of the _Principled BSDF_ node. Press `shitf-A`, go to _Input_ and select _Object Info_. Then drag its _Random_ output to the _Base Color_ input and you end up with sprinkles where the colors vary through the greyscale from white to black:

![img.png](random-color.png)

Everytime the sprinkle object is replicated, duplicated or referenced, _Random_ is used to provide a new value for _Base Color_. It's just producing a value from 0 to 1 on a gradient that currently goes from black, i.e. 0, to white, i.e. 1. To get a more interesting gradient, press `shitf-A`, go to _Converter_ and select _ColorRamp_. Drag the resulting node on top of the line between _Random_ and _Base Color_ and _Random_ will be automatically rewired to the the _Fac_ input on the new node and its _Color_ output will be wired through to _Base Color_:

![img.png](colorramp.png)

Click the black area in the _ColorRamp_ node, change it to e.g. bright red and see what happens (drag the _V_ value up to 1.0 first or everything stays black).

Now, to add more colors into the color ramp - just click the plus button three times to introduce three new color stops and then click the drop-down arrow to the right of the minus button and select _Distribute Stops Evenly_. Click each of the stops in turn, to select it, and then click on the color area below to change its color. Andrew used the following colors for the first four stops and left the right-most one as white:

* Blue - HSV 0.6, 0.45 and 1.
* Purple - HSV 0.76, 0.4 and 1.
* Hot pink - HSV 0.85, 0.54 and 1.
* Yellow - 0.16, 0.4 and 1

Selecting the stops is a little odd - they didn't always select when I clicked them - when you've selected one successfully, you'll see a dotted line appear above it.

![img.png](colorramp-pastel.png)

The sprinkles now have these colors - and every color in-between them. To limit our color ramp to just the colors of the stops, change the node's _Interpolation_ value from _Linear_ to _Constant_. The proportion of the color ramp that has a given color determines how many sprinkles have that color - as white is hard up against the right edge, no sprinkles have a white color, so go to the drop-down arrow to the left of the minus again and select _Distribute Stops from Left_:

![img.png](colorramp-constant-interpolation.png)

_If_ you want way more hot-pink sprinkles just drag things such that hot-pink takes up way more of the color ramp.

As a last step adjust the _Roughness_ value (either in the _Principled BSDF_ node or in _Material Properties_) to 0.8 for more chalky-style sprinkles.

![img.png](chalky-sprinkles.png)

#### Varying sprinkle size

Switch back to _Layout_ workspace and _Solid_ viewport shading mode and select the icing. If you go to _Particle Properties_ and then, in the _Render_ section, adjust the _Scale Randomness_ value (currently 0.1) up and down then we vary both their length and width, which isn't what we want, so leave it as it is.

So find the original sprinkle, select it, right click it and select _Duplicate Objects_ (or just press `shift-D`) and drag it to the right (click and release MMB to make this easier, assuming you used NumPad `.` and `1` to get the sprinkle nicely focused in a front on view).

With the duplicate selected, `tab` into _Edit Mode_, toggle on x-ray mode (`alt-Z`), select its top end, then `g` and `z` and then pull the top up until the sprinkle is twice as long:

![img.png](long-sprinkle.png)

`tab` out of edit mode and select each of the sprinkles in turn and, with `F2`, give them the names "Sprinkle_short" and "Sprinkle_long". Then select both, press `m` and move them to a _New Collection_ called "Sprinkles".

Aside: I kept mistakenly pressing `shitf-M` (rather than just `m`) and getting confused as to why I had a collection containing the sprinkles but they could still also be seen outside the collection in the _Outliner_. `shift-M` links the objects into a collection rather than moving them.

Then select the icing, go to _Particle Properties_ and, in the _Render_ section, change the _Render As_ value from _Object_ to _Collection_. Then in the _Collection_ section that's now appeared below, click on the _Instance Collection_ field and choose "Sprinkles".

![img.png](render-as-collection.png)

Switch to _Material Preview_ viewport shading mode (`z` and `2`) for a less-processing expensive view of the result than the _Render_ mode:

![img.png](long-and-short-sprinkles.png)

#### More variety

Select the original sprinkle and create a medium length one (in just the same way as the long one).

Select the long sprinkle, duplicate it, `tab` to _Edit Mode_ and select _Loop Cut_ in the toolbar along the left edge of the viewport (or just press `ctrl-R`):

![img.png](loop-cut.png)

Move the mouse around the select object and you can see the loop-cut outline move around showing different possible cuts. Move the mouse such that you get a loop around the middle of the sprinkle, then click, then move the mouse again to select where along the length of the sprinkle you want the cut - and now you've got a new set of vertices that allow you to add more detail to the object.

Alternatively, and what we'll do here, press `ctrl-R`, then move the mouse until the loop is around the middle again but now turn the scroll wheel to get additional loops - we just want two - then click and then right-click (the right-click just avoids the phase where you can place the cuts and just places them in their default positions).

Then with the middle section selected, press `g` and `x` and deform the sprinkle a bit:

![img.png](deformed-sprinkle.png)

Then select the ends and use `r` to rotate them nicely relative to the now bend body:

![img.png](deformed-sprikle-ends.png)

For an alternative way of doing much the same thing, duplicate the small sprinkle, `tab` to _Edit Mode_ and:

* Select the top of the sprinkle (with x-ray - `alt-Z`).
* Press `e` (to extrude) and pull up a little, click to release (but stay selected).
* Press `g` and pull to the side a bit, click to release.
* Press `r` (to rotate) until the middle section is a nice [isoceles trapezoid](https://mathworld.wolfram.com/IsoscelesTrapezoid.html) (see image below) - initially I was under-rotating at this point and getting a very odd shaped sprinkle.
* Repeat the `e`, `g` and `r` steps to pull out another segment.

![img.png](extrude-and-rotate.png)

In the end you should have a collection like this (the left-most one being the completed extruded sprinkle):

![img.png](five-sprinkle-shapes.png)

If you look at the donut now, things are looking good but we see the issue, commented on previously, that the center of gravity of each sprinkle seems to be one of the ends rather than the center - some of the sprinkles are sticking up out of the icing at a dramatic angle. This is due to the origin point - which you can see when you select an object:

![img.png](origin-points.png)

It's the little orange dot at the base of eahc of the selected sprinkles above. This origin point is the point at which the sprinkle attaches itself to the surface of the icing.

So with all the sprinkles selected, right-click, go to _Set Origin_ and select _Origin to Geometry_ and this centers the origin points:

![img.png](centered-origin-points.png)

Now, we've got all kinds of sprinkle shapes nicely laid out on our donut:

![img.png](donut-origin-centered-sprinkles.png)

### Intersection

If you look closely at the donut, you'll see that you've got particles, i.e. sprinkles, that are intersecting other particles.

Andrew explains that the particle system in Blender is a little old and there's just no good way to fix this. It should be able to examine the sprinkle mesh shapes and detect intersections but it can't. Andrew says that in Blender 2.83 or 2.84 the intention is to introduce particle nodes that can address this. However, I'm using Blender 2.92 and I've looked for information on developments on avoiding intersections - there are approaches but none of them are particularly simple (there's certainly no _Disable Intersections_ checkbox).

Andrew's suggestion, if you're particularly unhappy with some really odd clump of sprinkles or odd intersections, is to select the icing, go to the _Emission_ section of _Particle Properties_ and just keep on incrementing the _Seed_ value to force it to generate a new pattern of sprinkles and pick the one you're most happy with (temporarily turning off _Show Overlays_ makes it easier to see the sprinkles without the selection outlines):

![img.png](random-seed.png)

In particular, you may want to come back to _Seed_ when you're unhappy with something that shows up particularly clearly in a final high-quality render.

Aside: for a quick explanation of what a random seed is see the [random seed](https://en.wikipedia.org/wiki/Random_seed) Wikipedia article or [here](https://stats.stackexchange.com/a/354379/322395) on the stats StackExchange.

### Adding balls as an additional sprinkle type

As noted before the 3D cursor determines where new objects are added, so press `shift-RMB` and move it out to the left of the sprinkles (you can return it, later, to its default location with `shift-C`).

Then `shift-A` and add a new _UV Sphere_ (under _Mesh_) - it'll start as absolutely massive relative to the existing sprinkles, so in the _Add UV Sphere_ dialog change _Segments_ to 16, _Rings_ to 8 and _Radius_ to 4mm.

Select it, right-click and select _Shade Smooth_, then `g` and move it to where you want it relative to the other sprinkles.

Note: the existing sprinkles all share a common material, i.e. it's not simply duplicated with them. If you e.g. adjust the roughness for one then it affects all of them. The material isn't an attribute of an object - the material is a thing in its own right. When duplicating objects, you don't duplicate the material you simply duplicate a reference to it.

The sphere doesn't share the material that the existing sprinkles all share - which is good as we want to give the balls one fixed color. With the sphere selected, go to _Material Properties_, click _New_ and give it a _Base Color_ with e.g. HSV 0.52, 0.55 and 0.9 for an aqua color. And give it a _Roughness_ value of about 0.24 to make it quite shiny.

Note that you can expand the preview section to get a quick higher-quality preview on how it'll look:

![img.png](preview.png)

Select the sphere, press `m` and instead of creating a new collection, just select the "Sprinkles" collection from the list shown. If you'd had the "Sprinkles" collection selected in the _Outliner_ when you added the sphere then it would have ended up there automatically.

The donut looks pretty horrific now, we've got as many balls as we do of the other sprinkle variants:

![img.png](too-many-balls.png)

To fix this, select the icing, go to the _Collection_ section in the _Particle Properties_ and tick and expand the _Use Count_ item. By default, each item has a count that gives it equal weight:

![img.png](collection-counts-initial.png)

It's probably a good time to clean up the sprinkle names if some of them still have odd auto-generated names from when they were created.

You can now, as well as controlling the number of balls, give medium sprinkles more weight than long or show ones. So e.g. change the counts for short and long sprinkles to 30 and medium ones to 60 and leave the spheres at 1.

Note: as seen in the video leaving the sphere's count at 1 gives slightly too few spheres while 2 gives slightly too many. I thought this could be fixed by increasing all the counts by a factor of 10 which would allow me to then set the sphere's count to 15, i.e. like setting it to 1.5 before applying the factor of 10. But this didn't work out at all as I expected - in fact things get very strange. I suspect this has something to do with the size of these counts relative to the total number of particles being used (e.g. 800), e.g. it starts with the first item on the list and scatters the given count of those objects on the icing, goes on to the second list item, does the same and so on until its reached the desired number of particles (looping through the list again if necessary). So if you set the counts very high, you end up actually only using the first one or two objects in the list. For a really weird outcome set the cylinder like sprinkles to values of 60 or 30 (as suggested above) and set the sphere count to 400:

![img.png](strange-counts.png)

What's with the weird distribution of spheres that misses out a segment of the icing altogether?

**Update:** I asked about this [here](https://blender.stackexchange.com/q/223318/124535) on the Blender StackExchange and it turns out that this is an unusual situation where Andrew has missed out something important - the _Pick Random_ option. It turns out that the algorithm, that chooses particle objects, goes through the list repeatedly, laying down objects _in clumps_ according to the count assigned to each object, until it hits the total number of required particles. Things only look random when the counts are small enough that the algorithm has to go through the list many time, laying down clumps of one object on top of another such that eventually everything looks reasonably mixed up. But try increasing the counts such that they become large relative to the total number of particles and you notice the issue. You need to tick _Pick Random_ to resolve this issue. Once you've done this you can do what I wanted, i.e. assign the cyclindrical sprinkles values of 300 or 600 (rather than 30 or 60) and then assign the balls a value between 10 and 20 (giving you more control than you have when forced to choose either 1 or 2). I'd prefer to be able to assign objects a probability of being chosen, rather than a count, and I've asked about that [here](https://blender.stackexchange.com/q/223389/124535).

So, in the end, I ticked _Pick Random_ and used the following counts:

![img.png](pick-random.png)

Aside: yes, I'm aware that 15 is now a factor of all the counts and that one could use the values 20, 20, 40, 20, 40 and 1 instead.

So with e.g. the total number of particles set to 800 and so few balls, it's likely the balls don't end up very attractively placed - so bump the _Seed_ value until they end up nicely spread out.

![sprinkles render](render-finished-sprinkles.png)

Try also adjusting the _Number_ of particles value and the _Scale_ value, e.g. have few fat sprinkles (300 and 0.2) or many tiny sprinkles (1500 and 0.14).

We're now finished with the sprinkles.

Aside: at this stage (for no good reason), I suddenly wondered what the little dot is that you see to the right of every property in the property editor tabs. I failed to find this in the Blender documentation but, after some investigation, it seems clear it's a shortcut for right-clicking on the property and selecting _Insert Keyframe_. Inserting keyframes is covered (tersely) in the documentation [here](https://docs.blender.org/manual/en/latest/animation/keyframes/editing.html#insert-keyframe). If you click such a dot (or right-click etc.) the dot turns into a diamond, the field turns yellow and a little yellow diamond is placed in the _Timeline_ editor at the position of the playhead (see [here](https://docs.blender.org/manual/en/latest/editors/timeline.html) for the _Timeline_ documentation). E.g. here, I've clicked the dot to the right of the _Scale_ field:

![img.png](keyframe.png)

This isn't relevant to anything we're doing in this tutorial.

Level 2, Part 3 - texture painting
----------------------------------

...