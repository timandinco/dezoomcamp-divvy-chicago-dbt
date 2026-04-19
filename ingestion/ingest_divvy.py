import argparse
import io
import re
import zipfile
from pathlib import Path

import pandas as pd
import requests

BASE = "https://divvy-tripdata.s3.amazonaws.com/"


def download_zip_stream(url: str) -> bytes:
    with requests.get(url, stream=True, timeout=120) as r:
        r.raise_for_status()
        return r.content


def extract_csv_bytes(zip_bytes: bytes) -> bytes:
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as z:
        csv_names = [n for n in z.namelist() if n.lower().endswith(".csv")]
        if not csv_names:
            raise RuntimeError("No CSV found in zip")

        name = csv_names[0]
        with z.open(name) as f:
            return f.read()


def csv_to_parquet(csv_bytes: bytes, output_path: Path):
    df = pd.read_csv(io.BytesIO(csv_bytes))

    # Optional normalization
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]

    df.to_parquet(output_path, index=False)


def ingest_month(month: str, raw_dir: Path):
    if not re.fullmatch(r"\d{6}", month):
        raise ValueError(f"Invalid month {month}. Expected YYYYMM.")

    raw_dir.mkdir(parents=True, exist_ok=True)

    parquet_path = raw_dir / f"divvy_{month}.parquet"

    if parquet_path.exists():
        print(f"Skipping {month}, already exists")
        return parquet_path

    url = f"{BASE}{month}-divvy-tripdata.zip"
    print(f"Downloading {url}")

    zip_bytes = download_zip_stream(url)
    csv_bytes = extract_csv_bytes(zip_bytes)

    print(f"Writing {parquet_path}")
    csv_to_parquet(csv_bytes, parquet_path)

    return parquet_path


def run(months, raw_dir):
    for m in months:
        ingest_month(m, raw_dir)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--months", nargs="+", required=True)
    parser.add_argument("--raw-dir", default="data/raw")

    args = parser.parse_args()

    run(args.months, Path(args.raw_dir))


if __name__ == "__main__":
    main()