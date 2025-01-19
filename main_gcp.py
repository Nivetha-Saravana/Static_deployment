import os
import mimetypes
from google.cloud import storage

def main():
    # Directory containing your files
    directory = '.'  # Root directory of the repository
    bucket_name = 'cloudportfolionive'
    
    # Check if GOOGLE_APPLICATION_CREDENTIALS is set
    gcp_credentials = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
    if not gcp_credentials:
        print("GCP credentials not found in environment variables.")
        return
    
    # Create a GCS client
    client = storage.Client()
    bucket = client.bucket(bucket_name)

    try:
        # Walk through the directory and upload files
        for root, dirs, files in os.walk(directory):
            for file in files:
                local_file = os.path.join(root, file)
                blob_name = os.path.relpath(local_file, directory)  # Use relative path as GCS object key
                
                # Guess the content type based on the file extension
                content_type, _ = mimetypes.guess_type(local_file)
                if content_type is None:
                    content_type = 'application/octet-stream'  # Default to binary
                
                # Upload the file to GCS
                blob = bucket.blob(blob_name)
                blob.upload_from_filename(local_file, content_type=content_type, if_generation_match=0)
                print(f"Uploaded: {local_file} -> gs://{bucket_name}/{blob_name} with Content-Type {content_type}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
