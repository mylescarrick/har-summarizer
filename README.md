# har-summarizer

HAR files are a handy way of seeing all the resources loaded on a page. They're not really designed to be human-readable though – JSON files that are often tens of thousands of lines long.

At this point the parser builds 3 CSV files (tab-delimeted):

1. Full resources list, including (Verb/Method, HTTP Version), hostname, path, and resource size
2. List of hostnames, sum of resource size, count of resources)
3. List of currently-resolving IP addresses + info from (2) above (repeated if multiple IPs for a given hostname



Here's how to get started

## Clone this repo

```
git clone https://github.com/mylescarrick/har-summarizer.git

cd har-summarizer
```

You're ready to roll.



## Parse an HAR file

1. Go to Browser dev tools in a page... and in the Network tab hit the Download ↓ button

2. Save the HAR file into the 

3. Run the parser

   ```
   ./parse.rb har/your-saved-har.har
   ```

   

It's currently a little inelegant... but should give you a bunch of shiny CSVs (tab-separated) to inspect in the `/reports` folder.