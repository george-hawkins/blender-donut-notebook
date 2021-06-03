Blend modes
===========

If you look at the Blender documentation for [blend modes](https://docs.blender.org/manual/en/latest/editors/texture_node/types/color/mix_rgb.html?highlight=mixrgb#properties), it doesn't explain them but instead likes to a glossary entry that itself just links to the Gimp [layer modes](https://docs.gimp.org/en/gimp-concepts-layer-modes.html) documentation.

But this isn't terribly helpful as, for whatever reason, Blender has settled on different names for these modes to those used in tools like Gimp and Photoshop.

Thankfully Yevgeny Makarov provides a mapping between the Blender names and the names commonly used elsewhere (in this [post](https://devtalk.blender.org/t/solved-blend-modes-naming-inconsistency/8006) about the inconsistencies). Some of the inconsistencies have been resolved since Yevgeny's post - this table shows the naming now used in Blender 2.9:



| Blender | Photoshop |
|--------|--------|
| Mix | Normal |
| Darken | Darken |
| Multiply | Multiply |
| Color Burn | Color Burn |
| Lighten | Lighten |
| Screen | Screen |
| Color Dodge | Color Dodge |
| Add | Linear Dodge (Add) |
| Overlay | Overlay |
| Soft Light | Soft Light |
| Linear Light | Linear Light |
| Difference | Difference |
| Subtract | Subtract |
| Divide | Divide |
| Hue | Hue |
| Saturation | Saturation |
| Color | Color |
| Value | Luminosity |

As you can see, there are only a few inconsistencies left now:

| Blender | Photoshop |
|--------|--------|
| Mix | Normal |
| Add | Linear Dodge (Add) |
| Value | Luminosity |

So, most importantly, don't confuse _Mix_ in Blender with the (rarely used) _Hard Mix_ mode found in Photoshop and Gimp.

As well as the (very incomplete) Gimp documentation, linked to above, there's lots of pages, on these modes, around the web. The two clearest ones, that I found, are this [one](https://www.slrlounge.com/workshop/the-ultimate-visual-guide-to-understanding-blend-modes/) from SLR Lounge (looking at these modes in Photoshop) and this [one](https://highrise.digital/blog/css-blend-modes/) from Highrise Digital (looking at these modes in CSS). However, those two links only cover greyscale and transparency - color introduces more complexity and its covered here (without looking at transparency at all) in this [page](https://photoshoptrainingchannel.com/blending-modes-explained/) from the Photoshop Training Channel.

It's interesting to see that with Mix/Normal there's actually no blending occurring - the alpha values of the pixels in the upper image determine how much of the underlying image is seen, so if the alpha values are all 100% in the upper image, you only see it.

YouTube
-------

There are no end of videos on YouTube about blend modes - e.g. this [one](https://www.youtube.com/watch?v=QfGKdsz1pVM) from someone who usually focuses on Blender (but in this video treats blending as a general topic) or this [crash course](https://www.youtube.com/watch?v=EroAHgpsP_I) for blend modes in Photoshop or this more detailed [one](https://www.youtube.com/watch?v=zGTbOfhyXnA) (that just covers four modes).

Some videos just look at the mechanics of what each mode does without making it clear when and why you might use a particular mode. Some explain the maths of what's going on (which I find helpful). So just find whatever works for you.
