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

= Algorithm design process
In this part, we mainly introduce the process of how we design our algorithm one step by one step. This means that we will firstly design the algorithm in the simplest way, and then we will improve it step by step. The characteristic frequency of the fault will gradually become clear during this process.

== Preparation
=== Import the Data
We take the data from the file `100.csv` as an example.
#figure(image("./pics/100csv_time.png", width: 100%), numbering: none)

It can be found that in the original time domain signal, there are many frequency signals mixed. In particular, many high-frequency signals make the picture look cluttered. It's hard to tell us anything useful with the naked eye.
=== Define the Faults
With information in the slides, we know that there exists four kinds of potential faults in the data:
$
"BPFO" = n * "fr" / 2 * (1 - d / D * cos A) \
"BPFI" = n * "fr" / 2 * (1 + d / D * cos A) \
"BSF" = "fr" / 2 * D / d * (1 - (d / D * cos A)^2) \
"FTF" = "fr" / 2 * (1 - d / D * cos A)
$
with all values of variables $n$, $d$, $D$, $A$ and $"fr"$ are given. For data of `100.csv`, they are:
#figure(
  table(
    columns: 5,
    [Fault], [BPFO], [BPFI], [BSF], [FTF],
    [Fre], [107.9], [172.1], [45.4], [13.5],
  ),
  caption: [Frequence of faults],
)
== Perform FFT
We do FFT directly on the original signal to get the distribution of each frequency in the signal. The result is shown in the figure below:
#figure(image("./pics/FFT_out.png", width: 100%), numbering: none)

The four red dashed lines in the figure are the four possible failures that we calculated earlier. In this figure, we find that there seems to be no corresponding failure frequency in the graph. Does this mean that our bearings do not have a fault code? We are skeptical.
== Carry Out envelope analysis
Mechanical failure often leads to shock vibration in mechanical systems. These shock vibrations usually appear as a series of short-time pulses in the vibration signal with a large amplitude but a short duration.

These pulses excite the natural vibrations of the mechanical system, forming a series of amplitude-modulated oscillations. That is, the vibration signal consists of the product of a carrier (the natural frequency of the system) and a modulated signal (the shock pulse train). (Content of TP 2024.5.13)

Through envelope analysis, we can extract the envelope of the modulated signal from the modulated vibration signal, that is, those impulse sequences. The following figure shows the envelope of the modulated signal:
#figure(image("./pics/env_out_whole.png", width: 100%), numbering: none)
Because of the high frequency of the signal, it is difficult for us to analyze the useful results. Let's take a relatively short time domain:
#figure(image("./pics/env_out_part.png", width: 100%), numbering: none)
There are roughly three steps to calculate the envelope signal, which will not be detailed here.

We found that the envelope analysis appears to filter out some of the high-frequency noise, making our low-frequency features more pronounced.

At this step, we may be able to diagnose FTF type faults.
#figure(image("./pics/env_psd_out.png", width: 100%), numbering: none)

== Carry Out Spectral Kurtosis Analysis
In order to better detect, we carry out spectral warping analysis. 

Spectral kurtosis is able to enhance transient components because transient components typically have larger fourth-order cumulants, while noise and other background components have smaller fourth-order cumulants.And we also know that fault signals are usually transient signals. By calculating the fourth-order cumulant distribution over the frequency domain, the optimal band-pass frequency range can be determined automatically, and the energy of the transient components can be extracted effectively.

#figure(image("./pics/k.png", width: 100%), numbering: none)

In the above figure, we give the spectral kurtosis image and the envelope signal after filtering with a bandpass filter.

After this processing, we calculate its power spectral density and get:
#figure(image("./pics/100csv_res.png", width: 100%), numbering: none)

Therefore, we preliminarily determine that its fault type is FTF.

= Cases Analysis

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
