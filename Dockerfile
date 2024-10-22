# Use the official Jenkins LTS image as the base
FROM jenkins/jenkins:lts

# Switch to root user to install packages
USER root

# Update package lists and install required packages including ICU libraries and .NET SDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    apt-transport-https \
    libicu-dev \  
    && wget https://dot.net/v1/dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 8.0 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the environment variable for .NET
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="$PATH:$DOTNET_ROOT"

# Switch back to the Jenkins user
USER jenkins

# Set the default workspace for Jenkins
WORKDIR /var/jenkins_home/workspace