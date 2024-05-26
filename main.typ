#set page(paper: "us-letter")
#set heading(numbering: "1.1")

#let student-number = "No. 521260910012 & No. 521260910018"
// 这是注释
#figure(image("sjtu.png", width: 50%)) \ \ \

#show figure: it => {
  let cap = if it.caption != none { it.caption + " - " + student-number } else { student-number }
  align(center, box[#it.body #cap])
}


#align(center, text(17pt)[
  #set block(spacing: 2em)
  *Laboratory Report of Digital Signal Processing* \ \
  Name: Ye Heng & Fang Junjie \ \
  Student ID: #student-number \ \
  Date: 2024/5/25 \ \
  Score: #h(4em)
])

#pagebreak()

#set page(header: align(right)[
  Laboratory Report of Digital Signal Processing - Junjie FANG
], numbering: "1")
#set text(size: 11pt)

#outline()

= Analysis

== `100.csv`

We apply:

+ Envelope Analysis - the function `envelope()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

We get:

#figure(image("image.png", width: 90%)) \ \ \

Note that the red vertical lines in the figure represent integer multiples of the corresponding fault frequency.

We can't see any obvious fault frequency in the power density spectrum! The are almost
at the same height. However we can apply:

- Kurtosis Analysis - the function `fast_kurtogram()` (author: \@danielnewman09 on GitHub) in the code

And we get the Kurtosis Spectrum of this signal:

#figure(image("image2.png", width: 60%)) \ \ \

And the central frequency and bandwidth that we choose for the bandpass filter:

```
Max Level: 5.0
Max Kurtosis: 4.727322791301832
Cental Freq: 10600.0
Bandwidth: 400.0
```

to that signal.

So we apply

+ Bandpass filter with central frequency $10600"Hz"$ and bandwidth $400"Hz"$ - the function `bandpass_filter()` in the code
+ Envelope Analysis
+ Power Spectrum Analysis

And we get the following spectrum:

#figure(image("image3.png", width: 90%)) \ \ \

We can now tell the failure mode is *FTF*.

== `110.csv`

We apply:

+ Kurtosis Analysis - `spectral_kurtosis()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image4.jpg", width: 90%)) \ \ \

From which we can tell the failure mode is *BPFO*.

== `123.csv`

We apply:

+ Kurtosis Analysis - `spectral_kurtosis()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image5.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BPFO*.

== `144.csv`

We apply:

+ Kurtosis Analysis - `spectral_kurtosis()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image6.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BPFO*.

== `161.csv`

We apply:

+ Kurtosis Analysis - `spectral_kurtosis()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image7.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BPFO*.

== `486.csv`

We apply:

+ Kurtosis Analysis - `spectral_kurtosis()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image8.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BPFO* and *FTF*.

== `2365.csv`

We apply:

+ Envelope Analysis - the function `envelope()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image9.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BSF*.

== `2538.csv`

We apply:

+ Envelope Analysis - the function `envelope()` in the code
+ Envelope Analysis with a bandpass filter of parameters from Kurtosis Analysis - the function `envelope_analysis()` in the code
+ Power Spectrum Analysis - the function `power_spectral_density()` in the code

and get the image:

#figure(image("image10.jpg", width: 90%)) \ \ \

We can tell the failure mode is *BPFO*.

#align(center,
  table(
    columns: 2,
    inset: 10pt,
    align: center,
    [*signal*], [*failure mode*],
    [100.csv], [FTF],
    [110.csv], [BPFO],
    [123.csv], [BPFO],
    [144.csv], [BPFO],
    [161.csv], [BPFO],
    [486.csv], [BPFO, FTF],
    [2365.csv], [BSF],
    [2538.csv], [BPFO]
  )
)

= Appendix Code

See `main.ipynb`
