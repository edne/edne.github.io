---
layout: page
permalink: /
---

Hi! I'm an Engineering student at [Politecnico di Milano](http://polimi.it/en).

I spend most of my (spare) time coding and exploring languages.
Former pythonista, in the last year I fell in love with Lisp and the possibility
to compress concepts and grow abstractions. 

My first approach to programming was with computer graphics, in particular
fractals generation, and I'm still interested in generative art and creative coding.  

I'm not a security / pwning fan, but sometimes I play CTFs, they are great
accasions to learn as many things as possible in a small amount of time
(and I really like that!)

&nbsp;
&nbsp;
&nbsp;

# Projects

* ### [Pineal](https://github.com/edne/pineal)
  Graphic Synthesis Engine, for live performances.

* ### [Quine Logo](https://github.com/edne/quine-logo)
  Concept for a generative, ASCII-art, self-printing logo for the **Codice Inutile**
  (useless code) artist collective.

* ### [One Line Beat](https://github.com/edne/quine-logo)
  Bash utility to generate [byte-beats](http://canonical.org/%7Ekragen/bytebeat/)
  compiling on the fly a single line C program.

&nbsp;
&nbsp;
&nbsp;

# Blog

<ul class="post-list">
    {% for post in site.posts %}
      <li>
        <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>

        <h2>
          <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        </h2>
        {% if post.description %}
            {{ post.description }}
        {% endif %}
        {% if post.excerpt %}
            {{ post.excerpt }}
        {% endif %}
      </li>
    {% endfor %}
  </ul>

  <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>


